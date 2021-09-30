<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class UserDetail extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('userDetail', function(Blueprint $table) {
            $table->id();
            $table->string('userDetail_joinedGroupID');
            $table->string('userDetail_status');
            $table->integer('userDetail_accEnable');
            $table->string('userDetail_profilePictureDir');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('userDetail');
    }
}
