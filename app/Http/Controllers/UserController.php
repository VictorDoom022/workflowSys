<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User; 
use App\Models\UserDetail; 

class UserController extends Controller
{
    public function getUserByID($id){
        $user = User::findOrFail($id);

        return $user;
    }

    public function getAllUserData(){
        $user = User::orderBy('id')->get();
        $userDetail = UserDetail::orderBy('userDetail_id')->get();

        $response=[
            'user' => $user,
            'userDetail' => $userDetail,
        ];

        return $response;
    }
    
    public function deleteUser($id){
        $user = User::findOrFail($id);
        $user->delete();

        return [
            'message' => 'Deleted'
        ];
    }
}
