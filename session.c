/**
 * vnc2rdp: proxy for RDP client connect to VNC server
 *
 * Copyright 2014 Yiwei Li <leeyiw@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <stdlib.h>
#include <string.h>
#ifndef _WIN32
#include <sys/epoll.h>
#include <unistd.h>
#endif

#include "log.h"
#include "rdp.h"
#include "session.h"
#include "vnc.h"

v2r_session_t *
v2r_session_init(const v2r_session_opt_t *opt)
{
	v2r_session_t *s = NULL;

	s = (v2r_session_t *)malloc(sizeof(v2r_session_t));
	if (s == NULL) {
		goto fail;
	}
	memset(s, 0, sizeof(v2r_session_t));

	s->opt = opt;

	/* connect to VNC server */
	s->vnc = v2r_vnc_init(s);
	if (s->vnc == NULL) {
		v2r_log_error("connect to vnc server error");
		goto fail;
	}
	v2r_log_info("connect to vnc server success");

	/* accept RDP connection */
	s->rdp = v2r_rdp_init(s);
	if (s->rdp == NULL) {
		v2r_log_error("accept new rdp connection error");
		goto fail;
	}
	v2r_log_info("accept new rdp connection success");

	return s;

fail:
	v2r_session_destory(s);
	return NULL;
}

void
v2r_session_destory(v2r_session_t *s)
{
	if (s == NULL) {
		return;
	}
	if (s->rdp != NULL) {
		v2r_rdp_destory(s->rdp);
	}
	if (s->vnc != NULL) {
		v2r_vnc_destory(s->vnc);
	}
#ifndef _WIN32
	if (s->epoll_fd != 0) {
		close(s->epoll_fd);
	}
#endif
	free(s);
}

int
v2r_session_build_conn(v2r_session_t *s, int client_fd, int server_fd)
{
	if (v2r_vnc_build_conn(s->vnc, server_fd) == -1) {
		goto fail;
	}
	if (v2r_rdp_build_conn(s->rdp, client_fd) == -1) {
		goto fail;
	}

	return 0;

fail:
	return -1;
}

#ifndef _WIN32
void
v2r_session_transmit(v2r_session_t *s)
{
	int i, nfds, rdp_fd, vnc_fd;
	struct epoll_event ev, events[MAX_EVENTS];

	s->epoll_fd = epoll_create(2);
	if (s->epoll_fd == -1) {
		goto fail;
	}

	rdp_fd = s->rdp->sec->mcs->x224->tpkt->fd;
	vnc_fd = s->vnc->fd;

	memset(&ev, 0, sizeof(ev));
	ev.events = EPOLLIN;
	ev.data.fd = rdp_fd;
	if (epoll_ctl(s->epoll_fd, EPOLL_CTL_ADD, rdp_fd, &ev) == -1) {
		goto fail;
	}

	memset(&ev, 0, sizeof(ev));
	ev.events = EPOLLIN;
	ev.data.fd = vnc_fd;
	if (epoll_ctl(s->epoll_fd, EPOLL_CTL_ADD, vnc_fd, &ev) == -1) {
		goto fail;
	}

	v2r_log_info("session transmit start");

	while (1) {
		nfds = epoll_wait(s->epoll_fd, events, MAX_EVENTS, -1);
		if (nfds == -1) {
			goto fail;
		}
		for (i = 0; i < nfds; i++) {
			if (events[i].data.fd == rdp_fd) {
				if (v2r_rdp_process(s->rdp) == -1) {
					goto fail;
				}
			} else if (events[i].data.fd == vnc_fd) {
				if (v2r_vnc_process(s->vnc) == -1) {
					goto fail;
				}
			}
		}
	}

fail:
	v2r_log_info("session transmit end");
	return;
}
#else
void
v2r_session_transmit(v2r_session_t *s)
{
	int nfds, rdp_fd, vnc_fd;
	fd_set read_set;

	rdp_fd = s->rdp->sec->mcs->x224->tpkt->fd;
	vnc_fd = s->vnc->fd;

	v2r_log_info("session transmit start");

	while (1) {
		FD_ZERO(&read_set);
		FD_SET(rdp_fd, &read_set);
		FD_SET(vnc_fd, &read_set);

		nfds = select(0, &read_set, NULL, NULL, NULL);
		if (nfds == SOCKET_ERROR) {
			goto fail;
		}
		if (FD_ISSET(rdp_fd, &read_set)) {
			if (v2r_rdp_process(s->rdp) == -1) {
				goto fail;
			}
		}
		if (FD_ISSET(vnc_fd, &read_set)) {
			if (v2r_vnc_process(s->vnc) == -1) {
				goto fail;
			}
		}
	}

fail:
	v2r_log_info("session transmit end");
	return;
}
#endif
