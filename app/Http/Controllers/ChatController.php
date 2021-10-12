<?php

namespace App\Http\Controllers;
use App\Models\Chat;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    public function sendMessage(Request $request){

        //variables that uses $request without validation
        $senderUserID = $request->senderUserID;
        $receiverUserID = $request->receiverUserID;

        $fields = $request->validate([
            'chatMessage' => ['required', 'string'],
        ]);

        $chat = Chat::create([
            'chat_senderUserID' => $senderUserID,
            'chat_receiverUserID' => $receiverUserID,
            'chat_message' => $fields['chatMessage'],
        ]);
    }

    public function getUserChat(Request $request){

        //variables that uses $request without validation
        $senderUserID = $request->senderUserID;
        $receiverUserID = $request->receiverUserID;

        $chat = Chat::where(function ($query) use ($receiverUserID, $senderUserID){
            $query->where('chat_receiverUserID', '=',$receiverUserID)
                ->where('chat_senderUserID', '=',$senderUserID);
        })->orWhere(function ($query) use ($receiverUserID, $senderUserID){
            $query->where('chat_receiverUserID', '=',$senderUserID)
                ->where('chat_senderUserID', '=',$receiverUserID);
        })->get();

        return response($chat, 200);
    }
}
