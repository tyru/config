# Install dependencies
set -ue
for i in ${depends[@]}; do
  dpkg -l $i >/dev/null 2>&1 ||
    sudo apt install -y $i
done
