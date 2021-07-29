<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Group;
use App\Models\Team;
use App\Models\UserDetail;

class GroupController extends Controller
{
    public function createGroup(Request $request){
        $fields = $request->validate([
            'groupName' => ['required', 'string'],
        ]);

        //create group table
        //set the create user as group admin and member
        $group=Group::create([
            'group_name' => $fields['groupName'],
            'group_joinCode' => str_random(10),
            'group_adminList' => $request->userID,
            'group_memberList' => $request->userID,
        ]);

        //update userDetail_joinID when create a group
        $userDetail = UserDetail::where('id', $request->userID)->first();
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
        //create default team
        $team=Team::create([
            'team_name' => 'General',
            'team_groupID' => $groupID,
            'team_memberID' => $request->userID,
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
    }

    public function getUserJoinedGroup($userID){
        //find all the group the user joined.
        $userDetail = UserDetail::where('id', $userID)->first();
        //get userDetail_joinedGroupID from User
        $userJoinedGroupListID = $userDetail->userDetail_joinedGroupID;
        //convert userJoinedGroupListID into an array by removing ','
        $groupStringArray = explode(',' , $userJoinedGroupListID);
        //loop the groupList array and store each value into groupArray
        $groupArray = [];        
        for($i=0; $i < count($groupStringArray); $i++) {
            $group = Group::where('id', $groupStringArray[$i])->first()->toArray();
            $groupArray[$i] = $group;
        }

        return $groupArray;
    }

    public function joinGroup(Request $request){
        $group = Group::where('group_joinCode', $request->joinCode)->first();
        // check if user is already join the group
        $groupMemberArray = explode(',' , $group->group_memberList);
        $userJoinedGroupBefore = false;

        for($i = 0; $i < count($groupMemberArray); $i++){
            if($groupMemberArray[$i] == $request->userID){
                //user already join the group
                $userJoinedGroupBefore = true;
                return [
                    'message'=>'You joined before.'
                ];
            }
        }

        if(!$userJoinedGroupBefore){
            //let the user join
            $userDetail = UserDetail::where('id', $request->userID)->first();
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
            $group->group_memberList = $group->group_memberList . ',' .$request->userID;
            $group->save();

            //let user join the default team
            $team = Team::where('team_groupID', $group->id)->first();
            $team->team_MemberID = $team->team_memberID . ',' .$request->userID;
            $team->save();
        }

        return [
            'message'=>'Group Joined.'
        ];
    }
}
