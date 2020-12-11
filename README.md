# Moon_API
https://moon.diploid.com/

Moon is an online tool to filter VCF files using the "knoledge base" from moon and patient HPO terms or a custom filter tree. The output will be a short list of most likely pathogenic varints. Also trio's can be analyzed.

In order to use the moon API to upload multiple patients or trio's, a few scripts are needed. 
You also need your personal token and corresponing mail adres known by moon in order to use the API, these are linked to your moon account.
see https://moon.diploid.com/account/api for your token and other information concerning the moon API.

All scripts come with a --help function. type ``` bash ${script}.sh -h ``` to see all variables needed.
All vcf files mention in a sample file are without extention. 
The scripts assume the extention is .vcf.gz.
___________________________________________________________________
#### Rename VCF files
use ``` renameVCF.sh ``` to pseudomize your VCF files, if you like.

____________________________________________________________________
#### Make a new project in Moon
use ```curl_project.sh``` to generated a new project in  moon.

Each project you make, will have a number. This number you need to mention in the patient file, so moon will know in which project your vcf's have to go.

___________________________________________________________________
#### Upload single patients
You need a patient file, with header, looking like this:

file,gender,projectNo,age,HPOterms                                                                                    
VCFfileNoExtention,female,11,34,HPO:0004756;HPO:00045678

use ```curl_single_patients.sh``` to upload all patients in your patient file.

__________________________________________________________________
#### Upload trio's
##### step 1: first upload the parents
you need a parents file with header, looking like this:

VCFfile,gender,projectNo                                                                    
VCFfileNoExtention,female,11

use ```curl_upload_parents.sh``` to upload all parents in your parents file.

You will get back a file in json format containing all files and moon numbers. To upload trio's you need the moon numbers for the parents.

##### step 2: Link the moon number to the parent VCF id.
you need python to do this.
```
ml Python
python readJsonFile.py -h
```
To see all the options. The json file is generated in step 1.

You need a sample file with the patients and the parents like this:

file,gender,projectNo,age,hpo_terms,mother,mother_health,father,father_health
VCFindex,male,12,3,HPO:0004756;HPO:00045678,VCFmother,healty,VCFfather,affected

The output is a sample file with the moon numbers linked to the parents. This file you need in the next step. 

##### step 3: upload the trio


use ```curl_upload_trios.sh``` to upload all trio's mentioned in the sample file from step 2.

____________________________________________________________________

#### start the analysis

```
curl -F "user_token=${MoonToken}" -F "user_email=${mailAdres}" https://moon.diploid.com/samples/{sampleNumbers..sampleNumbers}/analysis.json
```
