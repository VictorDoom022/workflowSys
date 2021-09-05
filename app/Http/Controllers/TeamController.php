<?php

namespace App\Http\Controllers;
use App\Models\Team;
use App\Models\Group;
use App\Models\TaskList;
use App\Models\Task;
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
        if(strlen($team->team_taskListID) == 0){
            $team->team_taskListID = $taskList->id; 
        }else{
            $team->team_taskListID = $team->team_taskListID. ',' .$taskList->id; 
        }
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

    public function getUserJoinedTeam(Request $request){

        //variables that uses $request without validation
        $teamID = $request->teamID;

        $team = Team::where('id', $teamID)->first();

        $teamMemberArray = explode(',', $team->team_memberID);
        $userArr = [];

        for($i=0; $i < count($teamMemberArray); $i++){
            $user = User::where('id', $teamMemberArray[$i])->first()->toArray();
            $userArr[$i] = $user;
        }

        return $userArr;
    }

    public function addMemberToTeam(Request $request){
        
        //variables that uses $request without validation
        $userList = $request->userList;
        $teamID = $request->teamID;

        $team = Team::where('id', $teamID)->first();
        if(strlen($team->team_memberID) != 0){
            $newTeamMemberList = $team->team_memberID . ',' .$userList;
        }else{
            $newTeamMemberList = $userList;
        }
        $team->team_memberID = $newTeamMemberList;
        $team->save();
        
        //create taskList for new member
        $newMemberArr = explode(',' , $userList);
        for($i=0; $i < count($newMemberArr); $i++){
            $this->createTaskList($teamID, $newMemberArr[$i]);
        }
        
        return [
            'message'=>'Member added.'
        ];
    }

    public function removeMemberFromTeam(Request $request){
        
        //variables that uses $request without validation
        $userList = $request->userList;
        $teamID = $request->teamID;

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

        return [
            'message'=>'Member removed.'
        ];
    }

    public function deleteTeam(Request $request){

        //variables that uses $request without validation
        $teamID = $request->teamID;

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

    public function renameTeam(Request $request){

        //variables that uses $request without validation
        $teamID = $request->teamID;

        $fields = $request->validate([
            'teamName' => ['required', 'string'],
        ]);

        $team = Team::where('id', $teamID)->first();
        $team->team_name = $fields['teamName'];
        $team->save();

        return [
            'message'=>'Team Renamed.',
        ];
    }
}
