<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Group;
use App\Models\Team;
use App\Models\UserDetail;
use App\Models\Task;
use App\Models\TaskList;
use App\Models\User;

class GroupController extends Controller
{
    public function createGroup(Request $request){
        
        //variables that uses $request without validation
        $userID = $request->userID;

        $fields = $request->validate([
            'groupName' => ['required', 'string'],
        ]);

        //create group table
        //set the create user as group admin and member
        $group=Group::create([
            'group_name' => $fields['groupName'],
            'group_joinCode' => str_random(10),
            'group_adminList' => $userID,
            'group_memberList' => $userID,
        ]);

        //update userDetail_joinID when create a group
        $userDetail = UserDetail::where('id', $userID)->first();
        //set current userJoinedGroup into a string
        $userJoinedGroupID = $userDetail->userDetail_joinedGroupID;
        //combine the string with current Group table ID
        if($userJoinedGroupID == ""){
            $userJoinedGroupIDNewAdded = $userJoinedGroupID . $group->id;
        }else{
            $userJoinedGroupIDNewAdded = $userJoinedGroupID . ',' .$group->id;
        }
        //save userJoinGroupID with the latest data
        $userDetail->userDetail_joinedGroupID = $userJoinedGroupIDNewAdded;
        $userDetail->save();

        $this->createDefaultTeam($group->id, $request);

        return response($group, 200);
    }

    public function createDefaultTeam($groupID, Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;

        //create default team
        $team=Team::create([
            'team_name' => 'General',
            'team_groupID' => $groupID,
            'team_memberID' => $userID,
        ]);

        $group=Group::where('id', $groupID)->first();
        //set current group_teamListID into a string
        $groupTeamListString = $group->group_teamListID;
        //combine string with current groupTeamListID
        if($groupTeamListString == ""){
            $groupTeamListNewString = $groupTeamListString . $team->id;
        }else{
            $groupTeamListNewString = $groupTeamListString . ',' . $team->id;
        }
        //save groupTeamListID with latest data
        $group->group_teamListID = $groupTeamListNewString;
        $group->save();

        $this->createTaskList($team->id, $userID);
    }

    public function createTaskList($teamID, $userID){
        $taskList = TaskList::create([
            'taskList_teamID' => $teamID,
            'taskList_userID' => $userID,
        ]);

        $team = Team::where('id', $teamID)->first();
        $team->team_taskListID = $taskList->id; 
        $team->save();
    }

    public function getUserJoinedGroup($userID){
        //find all the group the user joined.
        $userDetail = UserDetail::where('id', $userID)->first();
        //get userDetail_joinedGroupID from User
        $userJoinedGroupListID = $userDetail->userDetail_joinedGroupID;

        if($userJoinedGroupListID != ""){
            //convert userJoinedGroupListID into an array by removing ','
            $groupStringArray = explode(',' , $userJoinedGroupListID);
            //loop the groupList array and store each value into groupArray
            $groupArray = [];        
            for($i=0; $i < count($groupStringArray); $i++) {
                $group = Group::where('id', $groupStringArray[$i])->first()->toArray();
                $groupArray[$i] = $group;
            }

            return $groupArray;
        }else{
            return "";
        }
    }

    public function joinGroup(Request $request){

        //variables that uses $request without validation
        $joinCode = $request->joinCode;
        $userID = $request->userID;

        $group = Group::where('group_joinCode', $joinCode)->first();
        //check if user is already join the group & check if code is valid
        if($group != null){
            $groupMemberArray = explode(',' , $group->group_memberList);
            $userJoinedGroupBefore = false;

            for($i = 0; $i < count($groupMemberArray); $i++){
                if($groupMemberArray[$i] == $userID){
                    //user already join the group
                    $userJoinedGroupBefore = true;
                    return response([
                        'message'=>'You joined before.'
                    ],201);
                }
            }

            if(!$userJoinedGroupBefore){
                //let the user join
                $userDetail = UserDetail::where('id', $userID)->first();
                //set current userJoinedGroup into a string
                $userJoinedGroupID = $userDetail->userDetail_joinedGroupID;
                //combine the string with current Group table ID
                if($userJoinedGroupID == ""){
                    $userJoinedGroupIDNewAdded = $userJoinedGroupID . $group->id;
                }else{
                    $userJoinedGroupIDNewAdded = $userJoinedGroupID . ',' .$group->id;
                }
                //save userJoinGroupID with the latest data into userDetail
                $userDetail->userDetail_joinedGroupID = $userJoinedGroupIDNewAdded;
                $userDetail->save();
                
                //update group member list
                $group->group_memberList = $group->group_memberList . ',' .$userID;
                $group->save();

                //let user join the default team
                $team = Team::where('team_groupID', $group->id)->first();
                $team->team_MemberID = $team->team_memberID . ',' .$userID;
                $team->save();

                //generate task list in default team
                $this->createTaskList($team->id, $userID);
            }

            return [
                'message'=>'Group Joined.'
            ];
        }else{
            return response([
                'message'=>'Code invalid/Group does not exist.'
            ], 201);
        }        
    }

    public function getGroupDetailByGroupUserID(Request $request){

        //variables that uses $request without validation
        $groupID = $request->groupID;
        $userID = $request->userID;

        $group = Group::where('id', $groupID)->first();
        $team = Team::where('team_groupID', $groupID)
                        ->where('team_memberID', 'like', '%'.$userID.'%')
                        ->get();

        $response=[
            'group' => $group,
            'team' => $team,
        ];

        return response($response, 200);
    }

    public function getGroupTeamByGroupID(Request $request){

        //variables that uses $request without validation
        $groupID = $request->groupID;

        $team = Team::where('team_groupID', $groupID)->get();

        return response($team, 200);
    }

    public function getGroupUserByGroupID(Request $request){
        //variables that uses $request without validation
        $groupID = $request->groupID;
        
        $group = Group::where('id', $groupID)->first();
        $groupMemberList = $group->group_memberList;
        $userArr = [];

        if(strlen($groupMemberList) != 0){
            $groupMemberListArray = explode(',', $groupMemberList);
            
            for($i = 0; $i < count($groupMemberListArray); $i++){
                $user = User::where('id', $groupMemberListArray[$i])->first()->toArray();
                $userArr[$i] = $user;
            }
        }

        return response($userArr, 200);
    }

    public function getGroupNonAdminUser(Request $request){
        //variables that uses $request without validation
        $groupID = $request->groupID;
        
        $group = Group::where('id', $groupID)->first();
        $groupAdminList = $group->group_adminList;
        $groupMemberList = $group->group_memberList;

        $groupAdminListArray = explode(',' , $groupAdminList);
        $groupMemberListArray = explode(',', $groupMemberList);
        $nonAdminUserListArray = array_merge(array_diff($groupMemberListArray, $groupAdminListArray));
        
        $userArr = [];
        for($i = 0; $i < count($nonAdminUserListArray); $i++){
            $user = User::where('id', $nonAdminUserListArray[$i])->first()->toArray();
            $userArr[$i] = $user;
        }

        return response($userArr, 200);
    }

    public function getGroupAdminUser(Request $request){
        //variables that uses $request without validation
        $groupID = $request->groupID;
        
        $group = Group::where('id', $groupID)->first();
        $groupAdminList = $group->group_adminList;

        $groupAdminListArray = explode(',' , $groupAdminList);
        
        $userArr = [];
        for($i = 0; $i < count($groupAdminListArray); $i++){
            $user = User::where('id', $groupAdminListArray[$i])->first()->toArray();
            $userArr[$i] = $user;
        }

        return response($userArr, 200);
    }

    public function setMemberAsAdmin(Request $request){
        //variables that uses $request without validation
        $groupID = $request->groupID;
        $userList = $request->userList;

        $group = Group::where('id', $groupID)->first();
        $currentGroupAdminList = $group->group_adminList;

        //convert adminList and userList into array
        $currentGroupAdminListArray = explode(',' , $currentGroupAdminList);
        $userListArray = explode(',' , $userList);
        //merge two arrays
        $newAdminListArray = array_merge($currentGroupAdminListArray, $userListArray);
        //convert back to string
        $newAdminList = implode(',', $newAdminListArray);
        //save it
        $group->group_adminList = $newAdminList;
        $group->save();

        return [
            'message'=>'Member(s) added.'
        ];
    }

    public function removeMemberFromGroupAdmin(Request $request){
        //variables that uses $request without validation
        $groupID = $request->groupID;
        $userList = $request->userList;

        $group = Group::where('id', $groupID)->first();
        $currentGroupAdminList = $group->group_adminList;

        $currentGroupAdminListArray = explode(',' , $currentGroupAdminList);
        $toBeRemovedUserList = explode(',' , $userList);

        $newAdminListArray = array_merge(array_diff($currentGroupAdminListArray, $toBeRemovedUserList));
        $newAdminList = implode(', ', $newAdminListArray);

        $group->group_adminList = $newAdminList;
        $group->save();

        return [
            'message'=>'Member(s) removed.'
        ];
    }

    public function deleteGroup($groupID){
        //get the teamList of the group first
        $group = Group::where('id', $groupID)->first();
        $groupTeamListArray = explode(',', $group->group_teamListID);

        //loop for deleting team & taskList
        for($i=0; $i < count($groupTeamListArray); $i++){
            //get team task list
            $this->deleteTeam($groupTeamListArray[$i]);
        }

        //get all userDetail who joined the group
        $userDetail = UserDetail::where('userDetail_joinedGroupID', 'like', '%'.$groupID.'%')->get();
        for($k=0; $k < count($userDetail); $k++){
            $currentUserJoinedGroup = $userDetail[$k]->userDetail_joinedGroupID;
            $currentUserJoinedGroupArr = explode(',',$currentUserJoinedGroup);

            for($x=0; $x < count($currentUserJoinedGroupArr); $x++){
                if($currentUserJoinedGroupArr[$x] == $groupID){
                    //remove the group being deleted from the array
                    unset($currentUserJoinedGroupArr[$x]);
                }
            }

            $newUserJoinedGroup = implode(',', $currentUserJoinedGroupArr);

            //save userDetail with new userDetail by getting current looped id
            $saveCurrentUserDetail = UserDetail::where('id', $userDetail[$k]->id)->first();
            $saveCurrentUserDetail->userDetail_joinedGroupID = $newUserJoinedGroup;
            $saveCurrentUserDetail->save();
        }
        
        //finally delete the group
        $group->delete();

        return [
            'message'=>'Group deleted.'
        ];
    }

    public function deleteTeam($teamID){

        $team = Team::where('id', $teamID)->delete();
        // get taskList data
        $taskList = TaskList::where('taskList_teamID', $teamID)->get();
        // get all taskList ID
        $taskListIDArr = [];
        // loop every $taskList and store taskList ID into array
        foreach($taskList as $task){
            array_push($taskListIDArr, $task->id);
        }

        // delete all task by taskListID
        // loop the stored taskListIDArr to delete task by id 
        for($i=0; $i<count($taskListIDArr); $i++){
            $task = Task::where('task_taskListID', $taskListIDArr[$i])->delete();
        }
        // delete the task list finally
        $taskList = TaskList::where('taskList_teamID', $teamID)->delete();

        return [
            'message'=>'Team Deleted.',
        ];
    }

    public function renameGroup(Request $request){

        //variables that uses $request without validation
        $groupID = $request->groupID;

        $fields = $request->validate([
            'groupName' => ['required', 'string'],
        ]);

        $group = Group::where('id', $groupID)->first();
        $group->group_name = $fields['groupName'];
        $group->save();

        return [
            'message'=>'Group Renamed.',
        ];
    }

    public function checkIsUserAdminByGroupID(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;
        $groupID = $request->groupID;

        $group = Group::where('id', $groupID)->first();
        $groupAdminList = $group->group_adminList;

        $groupAdminListArray = explode(',', $groupAdminList);
        $isAdmin = false;

        for($i = 0; $i < count($groupAdminListArray); $i++){
            if($groupAdminListArray[$i] == $userID){
                $isAdmin = true;
            }
        }

        return [
            'message'=>$isAdmin,
        ];
    }

    public function checkIsUserAdminByTeamID(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;
        $teamID = $request->teamID;

        // get Group ID from team
        $team = Team::where('id', $teamID)->first();
        $teamGroupID = $team->team_groupID;

        // get Group by ID
        $group = Group::where('id', $teamGroupID)->first();
        $groupAdminList = $group->group_adminList;

        $groupAdminListArray = explode(',', $groupAdminList);
        $isAdmin = false;

        for($i = 0; $i < count($groupAdminListArray); $i++){
            if($groupAdminListArray[$i] == $userID){
                $isAdmin = true;
            }
        }

        return [
            'message'=>$isAdmin,
        ];
    }

    public function removeMemberFromGroup(Request $request){

        //variables that uses $request without validation
        $groupID = $request->groupID;
        $userList = $request->userList;

        // remove selected userID from group_memberList
        $group = Group::where('id', $groupID)->first();
        $currentGroupMemberList = $group->group_memberList;
        $teamList = $group->group_teamListID;

        $currentGroupMemberListArray = explode(',', $currentGroupMemberList);
        $toBeRemovedUserListArray = explode(',', $userList);
        $currentTeamListArray = explode(',', $teamList);

        // find the difference between two arrays and merge them
        $newMemberListArray = array_merge(array_diff($toBeRemovedUserListArray, $currentTeamListArray));
        $newMemberList = implode(',', $newMemberListArray);

        // set the newMemberList as group_memberList
        $group->group_memberList = $newMemberList;

        // loop through the toBeRemovedUserListArray array to update userDetail_joinedGroupID
        for($i = 0; $i < count($toBeRemovedUserListArray); $i++){
            $userDetail = UserDetail::where('id', $toBeRemovedUserListArray[$i])->first();
            $userCurrentJoinedGroupID = $userDetail->userDetail_joinedGroupID;

            $userCurrentJoinedGroupIDArray = explode(',', $userCurrentJoinedGroupID);

            for($j=0; $j < count($userCurrentJoinedGroupIDArray); $j++){
                if($userCurrentJoinedGroupIDArray[$j] == $groupID){
                    unset($userCurrentJoinedGroupIDArray[$j]);
                }
            }

            $newUserJoinedGroup = implode(',', $userCurrentJoinedGroupIDArray);
            $userDetail->userDetail_joinedGroupID = $newUserJoinedGroup;
            $userDetail->save();
        }
        
        // remove member from team
        // loop through the currentTeamListArray array to remove them from each team
        for($i = 0; $i < count($currentTeamListArray); $i++){
            $this->removeMemberFromTeam($currentTeamListArray[$i],$userList);
        }

        $group->save();

        return [
            'message'=>'Member removed',
        ];
    }

    // copied from TeamController
    public function removeMemberFromTeam($teamID, $userList){

        $team = Team::where('id', $teamID)->first();
        $teamMemberID = $team->team_memberID;

        $teamMemberArr = explode(',' , $teamMemberID);
        $removeUserListArr = explode(',' , $userList);

        // compare and merge user that remains in the team
        $remainingUser = array_merge(array_diff($teamMemberArr, $removeUserListArr));
        //convert array back to string
        $remainingUserString = implode(',', $remainingUser);
        // save the remainingUserString back to team's memberID
        $team->team_memberID = $remainingUserString;
        $team->save();

        for($i=0; $i<count($removeUserListArr); $i++){
            // remove user's task list
            $taskList = TaskList::where('taskList_userID', $removeUserListArr[$i])
                                ->where('taskList_teamID', $teamID)->first();

            // remove user's task
            $task = Task::where('task_taskListID', $taskList->id)->delete();
            $taskList->delete();
        }
    }
}
