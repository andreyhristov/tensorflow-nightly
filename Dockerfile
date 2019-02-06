FROM tensorflow/tensorflow:nightly-devel

WORKDIR /tensorflow

RUN apt-get update && apt-get install -y \
    wget \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN wget https://github.com/bazelbuild/bazel/releases/download/0.22.0/bazel-0.22.0-installer-linux-x86_64.sh
RUN chmod 777 bazel-0.22.0-installer-linux-x86_64.sh && ./bazel-0.22.0-installer-linux-x86_64.sh

RUN git pull
RUN ./configure
RUN bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
RUN ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow
RUN pip uninstall tensorflow \
    && pip install /tensorflow/tensorflow*.whl

RUN python -c "import tensorflow as tf; print(tf.__version__)"
