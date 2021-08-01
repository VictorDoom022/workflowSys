<?php

namespace App\Http\Controllers;
use App\Models\Team;
use App\Models\Group;
use App\Models\TaskList;
use App\Models\User;
use Illuminate\Http\Request;

class TeamController extends Controller
{
    public function createTeam(Request $request){

        //variables that uses $request without validation
        $groupID = $request->groupID;
        $userID = $request->userID;

        $fields = $request->validate([
            'teamName' => ['required', 'string'],
        ]);

        //create team
        $team=Team::create([
            'team_name' => $fields['teamName'],
            'team_groupID' => $groupID,
            'team_memberID' => $userID,
        ]);

        //update group_teamListID
        $group=Group::where('id', $groupID)->first();
        $groupTeamList = $group->group_teamListID;
        $groupTeamListNewString = $groupTeamList . ',' . $team->id;
        $group->group_teamListID = $groupTeamListNewString;
        $group->save();

        //generate taskList
        $this->createTaskList($team->id, $userID);

        return [
            'message'=>'Team created.'
        ];
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

    public function getTeamDetail(Request $request){

        //variables that uses $request without validation
        $teamID = $request->teamID;

        $team = Team::where('id', $teamID)->first();
        $taskList = TaskList::where('taskList_teamID', $teamID)->get();

        $response=[
            'team' => $team,
            'taskList' => $taskList,
        ];

        return response($response, 200);
    }

    
    public function getUserNotJoinedTeam(Request $request){

        //variables that uses $request without validation
        $groupID = $request->groupID;
        $teamID = $request->teamID;

        $group = Group::where('id', $groupID)->first();
        $team = Team::where('id', $teamID)->first();

        $groupMemberArray = explode(',' , $group->group_memberList);
        $teamMemberArray = explode(',', $team->team_memberID);
        
        //compare two arrays and merge them into a new array
        $diffMemberID = array_merge(array_diff($groupMemberArray, $teamMemberArray));
        $userArr = [];

        for($i=0; $i < count($diffMemberID); $i++){
            $user = User::where('id', $diffMemberID[$i])->first()->toArray();
            $userArr[$i] = $user;
        }

        return $userArr;
    }
}
