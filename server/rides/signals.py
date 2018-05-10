import django.dispatch

ride_added_signal = django.dispatch.Signal(
    providing_args=["ride", "caller"],
)

ride_updated_signal = django.dispatch.Signal(
    providing_args=["ride", "caller"],
)

ride_canceled_signal = django.dispatch.Signal(
    providing_args=["ride", "caller"],
)

rider_committed_signal = django.dispatch.Signal(
    providing_args=["ride", "commit", "committer"],
)

rider_uncommitted_signal = django.dispatch.Signal(
    providing_args=["ride", "commit", "committer"],
)

