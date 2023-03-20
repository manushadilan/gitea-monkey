# gitea-monkey
Mirror your all Github repositories into local Gitea server

* gitea-monkey is a bash script file that will mirror your all Github repos in to your own local Gitea server.
* This will help you to back up your all repos locally.
* This scripts only works for debian or debian varient Linux systems. But you can tweak easily for any other linux OS version.

### Installation

```
# clone or download the repo
$ git clone https://github.com/manushadilan/gitea-monkey

# change the working directory to gitea-monkey
$ cd gitea-monkey

# give execution permission to script files
$ chmod +x gitea-monkey.sh
$ chmod +x gitea-monkey-mirror.sh

# frist run gitea-monkey script with sudo permission to install gitea server locally
$ sudo ./gitea-monkey.sh

# After server installation, configure gitea settings and finish the installation.
```
![Image of finish](https://github.com/manushadilan/gitea-monkey/blob/main/Screenshot%20from%202023-03-20%2009-28-52.png)

* Create Gitea user and get access token

![Image of Gitea access token](https://github.com/manushadilan/gitea-monkey/blob/main/Screenshot%20from%202023-03-20%2011-28-20.png)

* Get Github acess token 

![Image of Github acess token](https://github.com/manushadilan/gitea-monkey/blob/main/Screenshot%20from%202023-03-20%2011-31-08.png)

* Mirror all repos

```
# run gitea-monkey-mirror script with sudo permission to mirror all repos 
$ sudo ./gitea-monkey-mirror.sh
```
### Support & Contributions

* Please ⭐️ this repository if this project helped you.
* Any kind of contributions are welcomed. :)

## License

This project is licensed under the Apache License 2.0 License.  [Read more](https://github.com/manushadilan/gitea-monkey/blob/master/LICENSE)
