<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Post extends Model
{

    const POST_TYPE_TEXT = 1;
    const POST_TYPE_LINK = 2;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'content', 'type', 'base_url', 'title', 'description', 'color', 'image_path'
    ];

    /**
     * The attributes excluded from the model's JSON form.
     *
     * @var array
     */
    protected $hidden = [
        
    ];

    public function getTypeAttribute($value)
    {
        if ($value === self::POST_TYPE_TEXT) {
            return 'text';
        } else if ($value === self::POST_TYPE_LINK) {
            return 'link';
        }
    }

}