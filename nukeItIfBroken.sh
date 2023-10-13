systemctl stop sssd
rm /var/lib/sss/{db,mc}/*
nscd -i group
sss_cache -E
systemctl start sssd
