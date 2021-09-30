<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User; 
use App\Models\UserDetail; 

class UserController extends Controller
{
    public function getUserByID($id){
        $user = User::where('id', $id)->first();
        $userDetail = UserDetail::where('id', $id)->first();

        $response=[
            'user' => $user,
            'userDetail' => $userDetail,
        ];

        return $response;
    }

    public function getAllUserData(){
        $user = User::orderBy('id')->get();
        $userDetail = UserDetail::orderBy('id')->get();

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

    public function setUserStatus(Request $request){

        //variables that uses $request without validation
        $userDetail_id = $request->userDetail_id;

        $fields = $request->validate([
            'statusMsg' => 'string'
        ]);

        $userDetail = UserDetail::where('id', $userDetail_id)->first();
        $userDetail->userDetail_status = $fields['statusMsg'];
        $userDetail->save();
        
        return [
            'message' => 'Edited'
        ];
    }

    public function toggleUserBan($id){
        $userDetail = UserDetail::where('id', $id)->first();

        if($userDetail->userDetail_accEnable == 1){
            $userDetail->userDetail_accEnable = 0;
        }else{
            $userDetail->userDetail_accEnable = 1;
        }
        $userDetail->save();
        
        return [
            'message' => 'Toggled'
        ];
    }

    public function uploadProfilePicture(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;

        //save the file into /public/upload/userProfilePictures/{userID}
        $profilePicture = time().'.'.$request->file('profilePicture')->getClientOriginalExtension();
        $filePath = 'upload/userProfilePictures/' . $userID;
        $fullFilePath = $request->file('profilePicture')->move(public_path($filePath), $profilePicture);

        //save the file's location to db
        $userDetail = UserDetail::where('id', $userID)->first();
        $userDetail->userDetail_profilePictureDir = $filePath . $profilePicture;
        $userDetail->save();

        return [
           'message' => 'Uploaded successfully',
        ];
    }
}
