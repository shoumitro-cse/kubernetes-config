https://www.youtube.com/watch?v=8QGpHQ2SyG8

# generate private and public key (2048 bit, username: shoumitro)
ssh-keygen -t rsa -f ~/.ssh/feedback -C shoumitro -b 2048

# get public key
cat ~/.ssh/feedback.pub

# public key add to metadata => sshkeys
https://console.cloud.google.com/compute/metadata?project=maximal-arcade-372908&tab=sshkeys

ssh -i ~/.ssh/feedback shoumitro@35.247.75.85




################################## ssh key ###########################################
# Enter feedback VM instance for user ubuntu & root
ssh -i ~/.ssh/feedback ubuntu@35.247.75.85
ssh -i ~/.ssh/feedback_root root@35.247.75.85


# Enter worker-1 VM instance for user ubuntu & root
ssh -i ~/.ssh/feedback ubuntu@35.212.221.216
ssh -i ~/.ssh/feedback_root root@35.212.221.216



############### ssh key generate and add to google cloud ####################
# generate private and public key (2048 bit, username: shoumitro)
ssh-keygen -t rsa -f ~/.ssh/feedback -C ubuntu -b 2048
# get public key
cat ~/.ssh/feedback.pub
# public key add to metadata => sshkeys
https://console.cloud.google.com/compute/metadata?project=maximal-arcade-372908&tab=sshkeys
ssh -i ~/.ssh/feedback ubuntu@35.247.75.85


#for root user
ssh-keygen -t rsa -f ~/.ssh/feedback_root -C root -b 2048
############################################################################



