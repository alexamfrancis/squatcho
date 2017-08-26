from flask import Flask
import os
import random
import requests
import json
from flask import jsonify, request
import operator
from pymongo import MongoClient
import pymongo
from math import sqrt
from bson.json_util import dumps
from bson.objectid import ObjectId
from flask import Flask
from flask_cors import CORS, cross_origin

print "CREATING DATABASE"
client = MongoClient()
db = client.squatchodb
userModel = db.userList
teamModel = db.teamList

# checks to find their team and returns team name, member ids
def getTeam(userId):
    teams = teamList.find()
    for team in teams:
        if team['leaderId'] is userId: return dumps(team)
        for pendingIds in team['pendingIds']:
            if userId in pendingIds:
                return dumps(team)
    return 'ERROR: No team for this user.'

# happlicationens when a user (pending) accepts an invitation, userId is the id of the member
def addMember(userId, teamName):
    print 'ADDING TEAM MEMBER'
    result = teamModel.find_one({'teamName':teamName})
    pendingIds = result['pendingIds']
    memberIds = result['memberIds']
    if userId in pendingIds: pendingIds.remove(userId)
    memberIds.applicationend(userId)
    response = teamModel.update_one({'userId':uid}, {'$set': {'pendingIds':pendingIds, 'memberIds':memberIds}})
    return dumps(response)

# only leaders can do this, userId is the id of the member to be removed
def removeMember(userId, teamName):
    print 'REMOVING TEAM MEMBER'
    result = teamModel.find_one({'teamName':teamName})
    pendingIds = result['pendingIds']
    memberIds = result['memberIds']
    if userId in pendingIds: pendingIds.remove(userId)
    if userId in memberIds: memberIds.remove(userId)
    response = teamModel.update_one({'userId':uid}, {'$set': {'pendingIds':pendingIds, 'memberIds':memberIds}})
    return dumps(response)

# only leaders can do this, userId is the id of the member
def inviteMember(userId, teamName):
    print 'INVITING TEAM MEMBER'
    result = teamModel.find_one({'teamName':teamName})
    pendingIds = result['pendingIds']
    pendingIds.applicationend(userId)
    response = teamModel.update_one({'userId':uid}, {'$set': {'pendingIds':pendingIds}})
    return dumps(response)

# called when a leader pays for their team, userId is the id of the leader
def addTeam(userId, teamName):
    print 'ADDING TEAM'
    if checkUnique(teamName):
        team = {'teamName':teamName, 'leaderId': userId, 'pendingIds': [], 'memberIds': []}
        teamModel.insert_one(team)
        return 'SUCCESS! Your team has been created. Add team members in the application.', teamName
    else:
        return 'ERROR: That team name is already taken.'

# called when a leader tries to add a team, retruns true if there are no other teams with that name
def checkUnique(teamName):
    result = teamModel.find_one({'teamName':teamName})
    if result is None:
        return True
    return False

def updateUserStatus(userId, status):
    userModel.update_one({'userId':uid}, {'$set': {'status':status}})

def updateUserTeam(userId, teamName):
    userModel.update_one({'userId':uid}, {'$set': {'teamName':teamName}})


application = Flask(__name__)
CORS(application)

@application.route('/hello')
def hello():
    return "Hello World!"

@application.route("/user", methods=['POST'])
def user():
    body = json.loads(request.data)
    email = body['email']
    userId = body['userId']
    print email, userId
    #check if user exists already
    obj = userModel.find_one({'userId':userId})
    if obj is not None: # user already exists
        print "WE EXIST FUCK"
        return dumps(obj)
    else:
        #new user!
        user = {'userId':userId, 'email': email, 'status': 'null'}
        result = userModel.insert_one(user)
        response = userModel.find_one({'_id':result.inserted_id})
        print "NEW USER: ", dumps(response)
        return dumps(response)

# called when someone accepts an invitation
@application.route("/accept", methods=['POST'])
def accept():
    body = json.loads(request.data)
    uid = body['userId']
    updateUserStatus(uid, 'member')
    response = userModel.find_one({'userId':uid})
    addMember(uid, response['team'])
    return dumps(response)

@application.route("/invite", methods=['POST'])
def invite():
    body = json.loads(request.data)
    uid = body['userId']
    team = body['teamName']
    updateUserTeam(uid, team)
    updateUserStatus(uid, 'pending')
    return inviteMember(uid, team)

@application.route("/remove", methods=['POST'])
def remove():
    body = json.loads(request.data)
    uid = body['userId']
    team = body['teamName']
    # remove the teamname field from user
    userModel.update({'userId':uid}, {'$unset': {'teamName':1}})
    updateUserStatus(uid, 'null')
    return removeMember(uid, teamName)


# returns a success string or a error string if the team name has been taken
@application.route("/newTeam", methods=['POST'])
def newTeam():
    body = json.loads(request.data)
    uid = body['userId']
    team = body['teamName']
    updateUserTeam(uid, team)
    updateUserStatus(uid, 'leader')
    return addTeam(uid, team)

# called by a leader to invite all available users that aren't on another team
@application.route("/availableUsers", methods=['GET'])
def availableUsers():
    response = userModel.find({'status':'null', 'status':'pending'})
    return dumps(response)

# checks to see if they're in anyone's pending, userId is the id of the member
@application.route("/checkPending", methods=['POST'])
def checkPending():
    body = json.loads(request.data)
    uid = body['userId']
    teams = teamList.find()
    for team in teams:
        for pendingIds in team['pendingIds']:
            if uid in pendingIds:
                return dumps(team)
    return 'ERROR: No requests pending.'
# print a nice greeting.
def say_hello(username = "World"):
    return '<p>Hello %s!</p>\n' % username

# some bits of text for the page.
header_text = '''
    <html>\n<head> <title>EB Flask Test</title> </head>\n<body>'''
instructions = '''
    <p><em>Hint</em>: This is a RESTful web service! Append a username
    to the URL (for example: <code>/Thelonious</code>) to say hello to
    someone specific.</p>\n'''
home_link = '<p><a href="/">Back</a></p>\n'
footer_text = '</body>\n</html>'

# add a rule for the index page.
application.add_url_rule('/', 'index', (lambda: header_text +
    say_hello() + instructions + footer_text))

# add a rule when the page is accessed with a name appended to the site
# URL.
application.add_url_rule('/<username>', (lambda username:
    header_text + say_hello(username) + home_link + footer_text))

# run the application.
if __name__ == "__main__":
    # Setting debug to True enables debug output. This line should be
    # removed before deploying a production application.
    application.debug = True
    application.run()
