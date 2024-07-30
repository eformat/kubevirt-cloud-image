# kubevirt-cloud-image

FC40 based image for testing and running VM's

Download a cloud image.

```bash
wget https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2
cp Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2 image.qcow2
```

Customize it.

```bash
virt-customize -a image.qcow2 --install iperf3,btop,tcpdump --selinux-relabel
```

Dockerfile

```bash
cat > Dockerfile << EOF
USER root
FROM scratch
ADD --chown=107:107 image.qcow2 /disk/
EOF
```

Build and push.

```bash
podman build -t quay.io/eformat/kubevirt-cloud-image -f Dockerfile
podman push quay.io/eformat/kubevirt-cloud-image:latest
```

Use in a Kubevirt VM.

```yaml
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: fedora
spec:
  running: true
  template:
    spec:
      architecture: amd64
      domain:
      volumes:
        - containerDisk:
            image: quay.io/eformat/kubevirt-cloud-image:latest
          name: containerdisk
```
