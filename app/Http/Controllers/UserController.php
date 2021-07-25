<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User; 

class UserController extends Controller
{
    public function getUserByID($id){
        $user = User::findOrFail($id);

        return $user;
    }

    public function getAllUserData(){
        $user = User::latest()->get();
        
        return $user;
    }
    
    public function deleteUser($id){
        $user = User::findOrFail($id);
        $user->delete();

        return [
            'message' => 'Deleted'
        ];
    }
}
