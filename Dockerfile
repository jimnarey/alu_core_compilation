FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y unzip wget qemu-system-aarch64 cloud-image-utils ssh && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY run_qemu.sh /usr/bin
RUN chmod a+x /usr/bin/run_qemu.sh

RUN groupadd --gid 1000 runuser && \
    useradd --home-dir /home/runuser --shell /bin/bash --uid 1000 --gid 1000 runuser && \
    mkdir -p /home/runuser && \
    chown -R runuser:runuser /home/runuser

USER runuser

RUN mkdir -p /home/runuser/alu_emu
WORKDIR /home/runuser/alu_emu
# RUN wget -nv https://github.com/jimnarey/alu-qemu-dev/raw/master/flash0.img.zip && \
#     wget -nv https://github.com/jimnarey/alu-qemu-dev/raw/master/flash1.img.zip && \
#     unzip flash0.img.zip && \
#     unzip flash1.img.zip && \
#     rm flash0.img.zip flash1.img.zip

RUN wget -nv https://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-arm64-uefi1.img && \
    wget -nv https://releases.linaro.org/components/kernel/uefi-linaro/16.02/release/qemu64/QEMU_EFI.fd


COPY cloud.txt /home/runuser/alu_emu
RUN mkdir -p /home/runuser/.ssh && \
    ssh-keygen -t rsa -f /home/runuser/.ssh/id_rsa -N '' && \
    sed -i "s,SSH_KEY,$(cat $HOME/.ssh/id_rsa.pub),g" cloud.txt && \
    cloud-localds --disk-format qcow2 cloud.img cloud.txt

CMD = ["/usr/bin/run_qemu.sh"]