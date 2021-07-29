<?php

namespace App\Http\Controllers;
use App\Models\Team;
use Illuminate\Http\Request;

class TeamController extends Controller
{
    public function createTeam(Request $request){

        //variables that uses $request without validation
        $teamGroupID = $request->teamGroupID;
        $teamMemberID = $request->teamMemberID;

        $fields = $request->validate([
            'teamName' => ['required', 'string'],
        ]);

        $team=Team::create([
            'team_name' => $fields['teamName'],
            'team_groupID' => $teamGroupID,
            'team_memberID' => $teamMemberID,
        ]);

        return $team;
    }
}
