/* Generated by wayland-scanner 1.20.0 */

#ifndef EXT_IDLE_NOTIFY_V1_CLIENT_PROTOCOL_H
#define EXT_IDLE_NOTIFY_V1_CLIENT_PROTOCOL_H

#include <stdint.h>
#include <stddef.h>
#include "wayland-client.h"

#ifdef  __cplusplus
extern "C" {
#endif

/**
 * @page page_ext_idle_notify_v1 The ext_idle_notify_v1 protocol
 * @section page_ifaces_ext_idle_notify_v1 Interfaces
 * - @subpage page_iface_ext_idle_notifier_v1 - idle notification manager
 * - @subpage page_iface_ext_idle_notification_v1 - idle notification
 * @section page_copyright_ext_idle_notify_v1 Copyright
 * <pre>
 *
 * Copyright © 2015 Martin Gräßlin
 * Copyright © 2022 Simon Ser
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice (including the next
 * paragraph) shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 * </pre>
 */
struct ext_idle_notification_v1;
struct ext_idle_notifier_v1;
struct wl_seat;

#ifndef EXT_IDLE_NOTIFIER_V1_INTERFACE
#define EXT_IDLE_NOTIFIER_V1_INTERFACE
/**
 * @page page_iface_ext_idle_notifier_v1 ext_idle_notifier_v1
 * @section page_iface_ext_idle_notifier_v1_desc Description
 *
 * This interface allows clients to monitor user idle status.
 *
 * After binding to this global, clients can create ext_idle_notification_v1
 * objects to get notified when the user is idle for a given amount of time.
 * @section page_iface_ext_idle_notifier_v1_api API
 * See @ref iface_ext_idle_notifier_v1.
 */
/**
 * @defgroup iface_ext_idle_notifier_v1 The ext_idle_notifier_v1 interface
 *
 * This interface allows clients to monitor user idle status.
 *
 * After binding to this global, clients can create ext_idle_notification_v1
 * objects to get notified when the user is idle for a given amount of time.
 */
extern const struct wl_interface ext_idle_notifier_v1_interface;
#endif
#ifndef EXT_IDLE_NOTIFICATION_V1_INTERFACE
#define EXT_IDLE_NOTIFICATION_V1_INTERFACE
/**
 * @page page_iface_ext_idle_notification_v1 ext_idle_notification_v1
 * @section page_iface_ext_idle_notification_v1_desc Description
 *
 * This interface is used by the compositor to send idle notification events
 * to clients.
 *
 * Initially the notification object is not idle. The notification object
 * becomes idle when no user activity has happened for at least the timeout
 * duration, starting from the creation of the notification object. User
 * activity may include input events or a presence sensor, but is
 * compositor-specific. If an idle inhibitor is active (e.g. another client
 * has created a zwp_idle_inhibitor_v1 on a visible surface), the compositor
 * must not make the notification object idle.
 *
 * When the notification object becomes idle, an idled event is sent. When
 * user activity starts again, the notification object stops being idle,
 * a resumed event is sent and the timeout is restarted.
 * @section page_iface_ext_idle_notification_v1_api API
 * See @ref iface_ext_idle_notification_v1.
 */
/**
 * @defgroup iface_ext_idle_notification_v1 The ext_idle_notification_v1 interface
 *
 * This interface is used by the compositor to send idle notification events
 * to clients.
 *
 * Initially the notification object is not idle. The notification object
 * becomes idle when no user activity has happened for at least the timeout
 * duration, starting from the creation of the notification object. User
 * activity may include input events or a presence sensor, but is
 * compositor-specific. If an idle inhibitor is active (e.g. another client
 * has created a zwp_idle_inhibitor_v1 on a visible surface), the compositor
 * must not make the notification object idle.
 *
 * When the notification object becomes idle, an idled event is sent. When
 * user activity starts again, the notification object stops being idle,
 * a resumed event is sent and the timeout is restarted.
 */
extern const struct wl_interface ext_idle_notification_v1_interface;
#endif

#define EXT_IDLE_NOTIFIER_V1_DESTROY 0
#define EXT_IDLE_NOTIFIER_V1_GET_IDLE_NOTIFICATION 1


/**
 * @ingroup iface_ext_idle_notifier_v1
 */
#define EXT_IDLE_NOTIFIER_V1_DESTROY_SINCE_VERSION 1
/**
 * @ingroup iface_ext_idle_notifier_v1
 */
#define EXT_IDLE_NOTIFIER_V1_GET_IDLE_NOTIFICATION_SINCE_VERSION 1

/** @ingroup iface_ext_idle_notifier_v1 */
static inline void
ext_idle_notifier_v1_set_user_data(struct ext_idle_notifier_v1 *ext_idle_notifier_v1, void *user_data)
{
	wl_proxy_set_user_data((struct wl_proxy *) ext_idle_notifier_v1, user_data);
}

/** @ingroup iface_ext_idle_notifier_v1 */
static inline void *
ext_idle_notifier_v1_get_user_data(struct ext_idle_notifier_v1 *ext_idle_notifier_v1)
{
	return wl_proxy_get_user_data((struct wl_proxy *) ext_idle_notifier_v1);
}

static inline uint32_t
ext_idle_notifier_v1_get_version(struct ext_idle_notifier_v1 *ext_idle_notifier_v1)
{
	return wl_proxy_get_version((struct wl_proxy *) ext_idle_notifier_v1);
}

/**
 * @ingroup iface_ext_idle_notifier_v1
 *
 * Destroy the manager object. All objects created via this interface
 * remain valid.
 */
static inline void
ext_idle_notifier_v1_destroy(struct ext_idle_notifier_v1 *ext_idle_notifier_v1)
{
	wl_proxy_marshal_flags((struct wl_proxy *) ext_idle_notifier_v1,
			 EXT_IDLE_NOTIFIER_V1_DESTROY, NULL, wl_proxy_get_version((struct wl_proxy *) ext_idle_notifier_v1), WL_MARSHAL_FLAG_DESTROY);
}

/**
 * @ingroup iface_ext_idle_notifier_v1
 *
 * Create a new idle notification object.
 *
 * The notification object has a minimum timeout duration and is tied to a
 * seat. The client will be notified if the seat is inactive for at least
 * the provided timeout. See ext_idle_notification_v1 for more details.
 *
 * A zero timeout is valid and means the client wants to be notified as
 * soon as possible when the seat is inactive.
 */
static inline struct ext_idle_notification_v1 *
ext_idle_notifier_v1_get_idle_notification(struct ext_idle_notifier_v1 *ext_idle_notifier_v1, uint32_t timeout, struct wl_seat *seat)
{
	struct wl_proxy *id;

	id = wl_proxy_marshal_flags((struct wl_proxy *) ext_idle_notifier_v1,
			 EXT_IDLE_NOTIFIER_V1_GET_IDLE_NOTIFICATION, &ext_idle_notification_v1_interface, wl_proxy_get_version((struct wl_proxy *) ext_idle_notifier_v1), 0, NULL, timeout, seat);

	return (struct ext_idle_notification_v1 *) id;
}

/**
 * @ingroup iface_ext_idle_notification_v1
 * @struct ext_idle_notification_v1_listener
 */
struct ext_idle_notification_v1_listener {
	/**
	 * notification object is idle
	 *
	 * This event is sent when the notification object becomes idle.
	 *
	 * It's a compositor protocol error to send this event twice
	 * without a resumed event in-between.
	 */
	void (*idled)(void *data,
		      struct ext_idle_notification_v1 *ext_idle_notification_v1);
	/**
	 * notification object is no longer idle
	 *
	 * This event is sent when the notification object stops being
	 * idle.
	 *
	 * It's a compositor protocol error to send this event twice
	 * without an idled event in-between. It's a compositor protocol
	 * error to send this event prior to any idled event.
	 */
	void (*resumed)(void *data,
			struct ext_idle_notification_v1 *ext_idle_notification_v1);
};

/**
 * @ingroup iface_ext_idle_notification_v1
 */
static inline int
ext_idle_notification_v1_add_listener(struct ext_idle_notification_v1 *ext_idle_notification_v1,
				      const struct ext_idle_notification_v1_listener *listener, void *data)
{
	return wl_proxy_add_listener((struct wl_proxy *) ext_idle_notification_v1,
				     (void (**)(void)) listener, data);
}

#define EXT_IDLE_NOTIFICATION_V1_DESTROY 0

/**
 * @ingroup iface_ext_idle_notification_v1
 */
#define EXT_IDLE_NOTIFICATION_V1_IDLED_SINCE_VERSION 1
/**
 * @ingroup iface_ext_idle_notification_v1
 */
#define EXT_IDLE_NOTIFICATION_V1_RESUMED_SINCE_VERSION 1

/**
 * @ingroup iface_ext_idle_notification_v1
 */
#define EXT_IDLE_NOTIFICATION_V1_DESTROY_SINCE_VERSION 1

/** @ingroup iface_ext_idle_notification_v1 */
static inline void
ext_idle_notification_v1_set_user_data(struct ext_idle_notification_v1 *ext_idle_notification_v1, void *user_data)
{
	wl_proxy_set_user_data((struct wl_proxy *) ext_idle_notification_v1, user_data);
}

/** @ingroup iface_ext_idle_notification_v1 */
static inline void *
ext_idle_notification_v1_get_user_data(struct ext_idle_notification_v1 *ext_idle_notification_v1)
{
	return wl_proxy_get_user_data((struct wl_proxy *) ext_idle_notification_v1);
}

static inline uint32_t
ext_idle_notification_v1_get_version(struct ext_idle_notification_v1 *ext_idle_notification_v1)
{
	return wl_proxy_get_version((struct wl_proxy *) ext_idle_notification_v1);
}

/**
 * @ingroup iface_ext_idle_notification_v1
 *
 * Destroy the notification object.
 */
static inline void
ext_idle_notification_v1_destroy(struct ext_idle_notification_v1 *ext_idle_notification_v1)
{
	wl_proxy_marshal_flags((struct wl_proxy *) ext_idle_notification_v1,
			 EXT_IDLE_NOTIFICATION_V1_DESTROY, NULL, wl_proxy_get_version((struct wl_proxy *) ext_idle_notification_v1), WL_MARSHAL_FLAG_DESTROY);
}

#ifdef  __cplusplus
}
#endif

#endif
