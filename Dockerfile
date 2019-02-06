FROM tensorflow/tensorflow:nightly-devel

WORKDIR /tensorflow
RUN git pull \
    && ./configure \
    && bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package \
    && ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow \
    && pip uninstall tensorflow \
    && pip install /tensorflow/tensorflow*.whl

RUN python -c "import tensorflow as tf; print(tf.__version__)"
