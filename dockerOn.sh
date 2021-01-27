root_directory=" /home/gitlab-runner/.ssh/id_rsa"

rsync -avz --exclude '.git*' --exclude '.git/' --exclude 'terraform/' --delete \
         -e "ssh -o StrictHostKeyChecking=no -i ${root_directory}" ../../ gitlab@"$2":/var/www/html/$3

