<?php

namespace App\Http\Controllers;
use App\Models\Comment;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    public function createComment(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;
        $taskID = $request->taskID;

        $fields = $request->validate([
            'commentDetails' => ['required', 'string'],
        ]);

        $comment = Comment::create([
            'comment_taskID' => $taskID,
            'comment_userID' => $userID,
            'comment_details' => $fields['commentDetails'],
        ]);

        return [
            'message'=>'Comment sent!.'
        ];
    }

    public function getCommentByTaskID(Request $request){

        //variables that uses $request without validation
        $taskID = $request->taskID;

        $comment = Comment::where('comment_taskID', $taskID)->get();

        return response($comment, 200);
    }
}
