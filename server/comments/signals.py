import django.dispatch

comment_added_signal = django.dispatch.Signal(
    providing_args=["ride", "comment", "commenter"],
)

