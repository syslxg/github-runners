apt-get update
apt-get install -y tmate
cat << EOF > $HOME/.tmate.conf
set -g tmate-server-host tmate.ppxp.team
set -g tmate-server-port 22
set -g tmate-server-rsa-fingerprint SHA256:f7hWpHuMnA1q7mE93KR/xCBPk6qYtWNYBkHHu0yGXl8
set -g tmate-server-ed25519-fingerprint SHA256:SzJ803aM8krxe5REM8XU1vhE+GbQt5Sx0lwyMmIES/Q
EOF

tmate="tmate -S /tmp/tmate.sock"
echo "creating new tmate session"
$tmate new-session -d
$tmate wait tmate-ready
echo "Fetcing connection strings"
tmateSSH=$($tmate display -p '#{tmate_ssh}')
echo $tmateSSH
sleep 60
echo done
