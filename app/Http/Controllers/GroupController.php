<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Group;
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
        $userJoinedGroupIDNewAdded = $userJoinedGroupID . $group->id;
        //save userJoinGroupID with the latest data
        $userDetail->userDetail_joinedGroupID = $userJoinedGroupIDNewAdded;
        $userDetail->save();

        $response=[
            'groups' => $group,
        ];

        return response($response, 200);
    }

    public function getUserJoinedGroup($userID){
        //find all the group the user joined.
        $userDetail = UserDetail::where('id', $userID)->first();
        //get userDetail_joinedGroupID from User
        $userJoinedGroupListID = $userDetail->userDetail_joinedGroupID;
        //get all group's data from group table
        
        $groupArray = [];        
        for($i=0; $i < strlen($userJoinedGroupListID); $i++) {
            $group = Group::where('id', $userJoinedGroupListID[$i])->first()->toArray();
            $groupArray[$i] = $group;
        }

        return $groupArray;
    }
}
