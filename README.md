This is a contrived learning experiment: provide a control script which will ues Ansible to de-provision and re-provision multiple nodes between two job roles.

Will assign nodes to spark or to mapreduce job role (hadoop)

Dependencies:
* Remote nodes with SSH set up
* Remote nodes "assigned" to existing roles in files mapreduce-workers.inv and spark-workers.inv

```
Usage: ./commando <command> <count>
command should be either morespark or morehadoop or status
count should be the number of machines to reassign
```

Example:
```
0-15:10 dannhowa@localhost commando$ ./commando status
[mapreduce-workers]
198.xx.xxx.27
198.xx.xxx.206

[spark-workers]
192.xxx.xxx.246
0-15:11 dannhowa@localhost commando$ ./commando morehadoop 2
I will try to allocate 2 nodes to hadoop
Insufficient capacity to assign 2 nodes to hadoop
2-15:11 dannhowa@localhost commando$ ./commando morespark 2
I will try to allocate 2 nodes to spark

PLAY [mapreduce-workers] ****************************************************** 
skipping: no hosts matched

PLAY RECAP ******************************************************************** 


PLAY [spark-workers] ********************************************************** 

GATHERING FACTS *************************************************************** 
ok: [198.xx.xxx.27]
ok: [192.xxx.xxx.246]
ok: [198.xx.xxx.206]

TASK: [Provision dev user] **************************************************** 
ok: [192.xxx.xxx.246] => {"append": false, "changed": false, "comment": "", "group": 1000, "home": "/home/dev", "name": "dev", "shell": "/bin/sh", "state": "present", "uid": 1000}                                                                                                                                         
ok: [198.xx.xxx.206] => {"append": false, "changed": false, "comment": "", "group": 1001, "home": "/home/dev", "name": "dev", "shell": "/bin/sh", "state": "present", "uid": 1001}                                                                                                                                          
ok: [198.xx.xxx.27] => {"append": false, "changed": false, "comment": "", "group": 1001, "home": "/home/dev", "name": "dev", "shell": "/bin/sh", "state": "present", "uid": 1001}                                                                                                                                           

TASK: [Create some tmp nodes] ************************************************* 
changed: [198.xx.xxx.27] => {"changed": true, "cmd": ["mkdir", "-p", "/scratch/tmp0"], "delta": "0:00:00.007475", "end": "2014-02-12 23:11:35.429713", "rc": 0, "start": "2014-02-12 23:11:35.422238", "stderr": "", "stdout": ""}                                                                                          
changed: [192.xxx.xxx.246] => {"changed": true, "cmd": ["mkdir", "-p", "/scratch/tmp0"], "delta": "0:00:00.005640", "end": "2014-02-12 23:11:34.214750", "rc": 0, "start": "2014-02-12 23:11:34.209110", "stderr": "", "stdout": ""}                                                                                        
changed: [198.xx.xxx.206] => {"changed": true, "cmd": ["mkdir", "-p", "/scratch/tmp0"], "delta": "0:00:00.007499", "end": "2014-02-12 23:11:35.445091", "rc": 0, "start": "2014-02-12 23:11:35.437592", "stderr": "", "stdout": ""}                                                                                         

TASK: [Halt TaskTracker] ****************************************************** 
changed: [192.xxx.xxx.246] => {"changed": true, "cmd": ["echo", "/opt/mapr/bin/tt_stop.sh"], "delta": "0:00:00.005774", "end": "2014-02-12 23:11:37.636745", "rc": 0, "start": "2014-02-12 23:11:37.630971", "stderr": "", "stdout": "/opt/mapr/bin/tt_stop.sh"}
changed: [198.xx.xxx.206] => {"changed": true, "cmd": ["echo", "/opt/mapr/bin/tt_stop.sh"], "delta": "0:00:00.006902", "end": "2014-02-12 23:11:38.943558", "rc": 0, "start": "2014-02-12 23:11:38.936656", "stderr": "", "stdout": "/opt/mapr/bin/tt_stop.sh"}
changed: [198.xx.xxx.27] => {"changed": true, "cmd": ["echo", "/opt/mapr/bin/tt_stop.sh"], "delta": "0:00:00.006970", "end": "2014-02-12 23:11:39.219408", "rc": 0, "start": "2014-02-12 23:11:39.212438", "stderr": "", "stdout": "/opt/mapr/bin/tt_stop.sh"}

TASK: [Ensure TaskTracker is not running] ************************************* 
changed: [198.xx.xxx.27] => {"changed": true, "cmd": "! ps x | grep TaskTracker | grep -qv grep ", "delta": "0:00:00.022833", "end": "2014-02-12 23:11:43.645503", "rc": 0, "start": "2014-02-12 23:11:43.622670", "stderr": "", "stdout": ""}
changed: [192.xxx.xxx.246] => {"changed": true, "cmd": "! ps x | grep TaskTracker | grep -qv grep ", "delta": "0:00:00.015065", "end": "2014-02-12 23:11:42.158113", "rc": 0, "start": "2014-02-12 23:11:42.143048", "stderr": "", "stdout": ""}
changed: [198.xx.xxx.206] => {"changed": true, "cmd": "! ps x | grep TaskTracker | grep -qv grep ", "delta": "0:00:00.019630", "end": "2014-02-12 23:11:43.434136", "rc": 0, "start": "2014-02-12 23:11:43.414506", "stderr": "", "stdout": ""}

TASK: [Assign scratch partitions to dev user] ********************************* 
changed: [198.xx.xxx.27] => {"changed": true, "cmd": "chown -R dev /scratch/tmp* ", "delta": "0:00:00.009151", "end": "2014-02-12 23:11:46.209264", "rc": 0, "start": "2014-02-12 23:11:46.200113", "stderr": "", "stdout": ""}
changed: [198.xx.xxx.206] => {"changed": true, "cmd": "chown -R dev /scratch/tmp* ", "delta": "0:00:00.009288", "end": "2014-02-12 23:11:46.942487", "rc": 0, "start": "2014-02-12 23:11:46.933199", "stderr": "", "stdout": ""}
changed: [192.xxx.xxx.246] => {"changed": true, "cmd": "chown -R dev /scratch/tmp* ", "delta": "0:00:00.007287", "end": "2014-02-12 23:11:45.865545", "rc": 0, "start": "2014-02-12 23:11:45.858258", "stderr": "", "stdout": ""}

TASK: [Provision mapred-site.xml] ********************************************* 
ok: [192.xxx.xxx.246] => {"changed": false, "gid": 0, "group": "root", "mode": "0600", "owner": "root", "path": "/opt/mapr/conf/mapred-site.xml", "size": 732, "state": "file", "uid": 0}
changed: [198.xx.xxx.27] => {"changed": true, "dest": "/opt/mapr/conf/mapred-site.xml", "gid": 0, "group": "root", "md5sum": "e715df9593a972bd3ebb83b6d1482b2c", "mode": "0644", "owner": "root", "size": 732, "src": "/root/.ansible/tmp/ansible-1392246706.98-193445539874259/source", "state": "file", "uid": 0}
changed: [198.xx.xxx.206] => {"changed": true, "dest": "/opt/mapr/conf/mapred-site.xml", "gid": 0, "group": "root", "md5sum": "3a1cfe1b2350169ac3d1825f1f37c60b", "mode": "0644", "owner": "root", "size": 732, "src": "/root/.ansible/tmp/ansible-1392246706.99-109430739269396/source", "state": "file", "uid": 0}

TASK: [Start Map-Reduce TaskTracker] ****************************************** 
changed: [198.xx.xxx.206] => {"changed": true, "cmd": ["echo", "/usr/local/spark/bin/worker_start.sh"], "delta": "0:00:00.006604", "end": "2014-02-12 23:11:56.248647", "rc": 0, "start": "2014-02-12 23:11:56.242043", "stderr": "", "stdout": "/usr/local/spark/bin/worker_start.sh"}
changed: [192.xxx.xxx.246] => {"changed": true, "cmd": ["echo", "/usr/local/spark/bin/worker_start.sh"], "delta": "0:00:00.005143", "end": "2014-02-12 23:11:55.808509", "rc": 0, "start": "2014-02-12 23:11:55.803366", "stderr": "", "stdout": "/usr/local/spark/bin/worker_start.sh"}
changed: [198.xx.xxx.27] => {"changed": true, "cmd": ["echo", "/usr/local/spark/bin/worker_start.sh"], "delta": "0:00:00.006565", "end": "2014-02-12 23:11:56.430916", "rc": 0, "start": "2014-02-12 23:11:56.424351", "stderr": "", "stdout": "/usr/local/spark/bin/worker_start.sh"}

PLAY RECAP ******************************************************************** 
192.xxx.xxx.246            : ok=8    changed=5    unreachable=0    failed=0   
198.xx.xxx.206             : ok=8    changed=6    unreachable=0    failed=0   
198.xx.xxx.27              : ok=8    changed=6    unreachable=0    failed=0   
```
