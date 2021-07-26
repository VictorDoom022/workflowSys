<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;


class UserDetail extends Model
{
    protected $table = 'userDetail';
    
    public $timestamps = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'userDetail_id',
        'userDetail_joinedGroupID',
        'userDetail_status',
        'userDetail_accEnable',
    ];
}
