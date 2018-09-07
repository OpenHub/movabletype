<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("archive_lib.php");
function smarty_block_mtcontentnext($args, $res, &$ctx, &$repeat) {
    if (!isset($res)) {
        $ctx->localize(array('content', 'conditional', 'else_content'));
        $content = $ctx->stash('content');
        if ($content) {
            $next_content = $ctx->mt->db()->fetch_next_prev_content('next', $args);
            $ctx->stash('content', $next_content);
        }
        $ctx->stash('conditional', isset($next_content));
        $ctx->stash('else_content', null);
    } else {
        if (!$ctx->stash('conditional')) {
            $res = $ctx->stash('else_content');
        }
        $ctx->restore(array('content', 'conditional', 'else_content'));
    }
    return $res;
}
?>

