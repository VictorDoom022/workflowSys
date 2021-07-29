<?php

namespace App\Http\Controllers;
use App\Models\Team;
use Illuminate\Http\Request;

class TeamController extends Controller
{
    public function createTeam(Request $request){
        $fields = $request->validate([
            'teamName' => ['required', 'string'],
        ]);

        $team=Team::create([
            'team_name' => $fields['teamName'],
            'team_groupID' => $request->teamGroupID,
            'team_memberID' => $request->teamMemberID,
        ]);

        return $team;
    }
}
