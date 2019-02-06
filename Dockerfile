FROM tensorflow/tensorflow:nightly-devel

WORKDIR /tensorflow

RUN curl "https://github-production-release-asset-2e65be.s3.amazonaws.com/20773773/63598600-2309-11e9-848f-e7b3ff38b1d2?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20190206%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20190206T084555Z&X-Amz-Expires=300&X-Amz-Signature=8c43590ee405ebb22742e4e4bbf5897880f74c92d826362de6094e8690f9a261&X-Amz-SignedHeaders=host&actor_id=296348&response-content-disposition=attachment%3B%20filename%3Dbazel-0.22.0-installer-linux-x86_64.sh&response-content-type=application%2Foctet-stream" -o bazel_installer.sh
RUN chmod 777 bazel_installer.sh && ./bazel_installer.sh

RUN git pull
RUN ./configure
RUN bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
RUN ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow
RUN pip uninstall tensorflow \
    && pip install /tensorflow/tensorflow*.whl

RUN python -c "import tensorflow as tf; print(tf.__version__)"
