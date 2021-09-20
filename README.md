# SAKABATō

   by bronxi
 
  *Sakabatō script checks the hardening
   level in GNU/Linux server.
   
  *This first version only have a basic
   checks with 3 individual test.
   

### This first version only have a basic checks with 3 individual test:

1) If root is the only user.

2) If remote connection as root is enable (all OPENssh package).

3) If remote connection with password is available.

4) If the port number is default (in process).

5) If firewall system is enable and only the minimum ports are allow (in process).

6) If there are tasks in crontab. If that's the case, checks who are the users and their file permissions (in process).


### It's easy!

Clone the repo, give it execute permissions and run the script!

- git clone https://github.com/bronxi47/sakabato.git
    
- chmod +x /sakabato/sakabato.sh
    
- bash /sakabato/sakabato.sh

![Sakabato console image](https://repository-images.githubusercontent.com/408206674/77696776-59ca-49fe-982c-34b2a20e8d50)





