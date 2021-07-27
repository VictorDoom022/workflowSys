<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Group extends Model
{
    use HasFactory;

    protected $table = 'group';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'group_name',
        'group_adminList',
        'group_memberList',
        'group_blockList',
        'group_teamListID',
        'group_joinCode',
    ];

    public function group_adminList(){
        return $this->hasMany(UserDetail::class, 'userDetail_joinedGroupID');
    }
}
