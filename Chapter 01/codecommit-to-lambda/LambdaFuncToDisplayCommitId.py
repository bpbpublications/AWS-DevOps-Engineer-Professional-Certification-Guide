import json
import os

import boto3
from botocore.exceptions import ClientError

codecommit = boto3.client('codecommit')

def getLastCommitLog(repository, commitId):
    response = codecommit.get_commit(
        repositoryName=repository,
        commitId=commitId
    )
    return response['commit']
    
def lambda_handler(event, context):
    repo_name = event['Records'][0]['eventSourceARN'].split(':')[-1]
    commit_hash = event['Records'][0]['codecommit']['references'][0]['commit']
    branchName = os.path.basename(
        str(event['Records'][0]['codecommit']['references'][0]['ref']))
        
     # Get commit ID for fetching the commit log
    if (commit_hash == None) or (commit_hash == '0000000000000000000000000000000000000000'):
        commit_hash = getLastCommitID(repo_name, branchName)

    print ("commit hash is : " + commit_hash)
