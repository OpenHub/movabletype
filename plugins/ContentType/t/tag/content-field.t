#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

use IPC::Open2;

use Test::Base;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test qw(:db);
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

my $mt = MT->instance;

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content data',
    blog_id => $blog_id,
);
my $cf_single_line_text = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'single line text',
    type            => 'single_line_text',
);
my $cf_multi_line_text = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'multi line text',
    type            => 'multi_line_text',
);
my $cf_number = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'number',
    type            => 'number',
);
my $cf_url = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'url',
    type            => 'url',
);
my $cf_embed = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'embed text',
    type            => 'embed_text',
);
my $cf_datetime = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'date and time',
    type            => 'date_and_time',
);
my $cf_date = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'date',
    type            => 'date',
);
my $cf_time = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'time',
    type            => 'time',
);
my $cf_select_box = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'select box',
    type            => 'select_box',
);
my $cf_radio = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'radio',
    type            => 'radio',
);
my $cf_checkbox = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'checkbox',
    type            => 'checkbox',
);
my $cf_list = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'list',
    type            => 'list',
);
my $cf_table = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'table',
    type            => 'table',
);
my $fields = [
    {   id        => $cf_single_line_text->id,
        order     => 1,
        type      => $cf_single_line_text->type,
        options   => { label => $cf_single_line_text->name },
        unique_id => $cf_single_line_text->unique_id,
    },
    {   id        => $cf_multi_line_text->id,
        order     => 2,
        type      => $cf_multi_line_text->type,
        options   => { label => $cf_multi_line_text->name },
        unique_id => $cf_multi_line_text->unique_id,
    },
    {   id        => $cf_number->id,
        order     => 3,
        type      => $cf_number->type,
        options   => { label => $cf_number->name },
        unique_id => $cf_number->unique_id,
    },
    {   id        => $cf_url->id,
        order     => 4,
        type      => $cf_url->type,
        options   => { label => $cf_url->name },
        unique_id => $cf_url->unique_id,
    },
    {   id        => $cf_embed->id,
        order     => 5,
        type      => $cf_embed->type,
        options   => { label => $cf_embed->name },
        unique_id => $cf_embed->unique_id,
    },
    {   id        => $cf_datetime->id,
        order     => 6,
        type      => $cf_datetime->type,
        options   => { label => $cf_datetime->name },
        unique_id => $cf_datetime->unique_id,
    },
    {   id        => $cf_date->id,
        order     => 7,
        type      => $cf_date->type,
        options   => { label => $cf_date->name },
        unique_id => $cf_date->unique_id,
    },
    {   id        => $cf_time->id,
        order     => 8,
        type      => $cf_time->type,
        options   => { label => $cf_time->name },
        unique_id => $cf_time->unique_id,
    },
    {   id      => $cf_select_box->id,
        order   => 9,
        type    => $cf_select_box->type,
        options => {
            label  => $cf_select_box->name,
            values => [
                { key => 'abc', value => 1 },
                { key => 'def', value => 2 },
                { key => 'ghi', value => 3 },
            ],
        },
        unique_id => $cf_select_box->unique_id,
    },
    {   id      => $cf_radio->id,
        order   => 10,
        type    => $cf_radio->type,
        options => {
            label  => $cf_radio->name,
            values => [
                { key => 'abc', value => 1 },
                { key => 'def', value => 2 },
                { key => 'ghi', value => 3 },
            ],
        },
        unique_id => $cf_radio->unique_id,
    },
    {   id      => $cf_checkbox->id,
        order   => 11,
        type    => $cf_checkbox->type,
        options => {
            label  => $cf_checkbox->name,
            values => [
                { key => 'abc', value => 1 },
                { key => 'def', value => 2 },
                { key => 'ghi', value => 3 },
            ],
            multiple => 1,
            max      => 3,
            min      => 1,
        },
        unique_id => $cf_checkbox->unique_id,
    },
    {   id      => $cf_list->id,
        order   => 12,
        type    => $cf_list->type,
        options => { label => $cf_list->name },
    },
    {   id      => $cf_table->id,
        order   => 13,
        type    => $cf_table->type,
        options => {
            label           => $cf_table->name,
            initial_row     => 3,
            initial_columns => 3,
            row_headers     => 'a,b,c',
            column_headers  => '1,2,3',
        },
    },
];
$ct->fields($fields);
$ct->save or die $ct->errstr;
my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    author_id       => 1,
    data            => {
        $cf_single_line_text->id => 'test single line text',
        $cf_multi_line_text->id  => "test multi line text\naaaaa",
        $cf_number->id           => '12345',
        $cf_url->id              => 'https://example.com/~abby',
        $cf_embed->id            => "abc\ndef",
        $cf_datetime->id         => '20170603180500',
        $cf_date->id             => '20170605000000',
        $cf_time->id             => '19700101123456',
        $cf_select_box->id       => [2],
        $cf_radio->id            => [3],
        $cf_checkbox->id         => [ 1, 3 ],
        $cf_list->id             => [ 'aaa', 'bbb', 'ccc' ],
        $cf_table->id            => "<tr><td>1</td><td></td><td></td></tr>\n"
            . "<tr><td></td><td>2</td><td></td></tr>\n"
            . "<tr><td></td><td></td><td>3</td></tr>"
    },
);

run {
    my $block = shift;

SKIP:
    {
        skip $block->skip, 1 if $block->skip;

        my $tmpl = $app->model('template')->new;
        $tmpl->text( $block->template );
        my $ctx = $tmpl->context;

        my $blog = MT::Blog->load($blog_id);
        $ctx->stash( 'blog',          $blog );
        $ctx->stash( 'blog_id',       $blog->id );
        $ctx->stash( 'local_blog_id', $blog->id );
        $ctx->stash( 'builder',       MT::Builder->new );

        my $result = eval { $tmpl->build };
        if ( defined $result ) {
            $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
            is( $result, $block->expected, $block->name );
        }
        else {
            $result = $ctx->errstr;
            $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
            is( $result, $block->error, $block->name . ' (error)' );
        }
    }
};

# sub php_test_script {
#     my ( $template, $text ) = @_;
#     $text ||= '';
#
#     my $test_script = <<PHP;
# <?php
# \$MT_HOME   = '@{[ $ENV{MT_HOME} ? $ENV{MT_HOME} : '.' ]}';
# \$MT_CONFIG = '@{[ $app->find_config ]}';
# \$blog_id   = '$blog_id';
# \$tmpl = <<<__TMPL__
# $template
# __TMPL__
# ;
# \$text = <<<__TMPL__
# $text
# __TMPL__
# ;
# PHP
#     $test_script .= <<'PHP';
# include_once($MT_HOME . '/php/mt.php');
# include_once($MT_HOME . '/php/lib/MTUtil.php');
#
# $mt = MT::get_instance(1, $MT_CONFIG);
# $mt->init_plugins();
#
# $db = $mt->db();
# $ctx =& $mt->context();
#
# $ctx->stash('blog_id', $blog_id);
# $ctx->stash('local_blog_id', $blog_id);
# $blog = $db->fetch_blog($blog_id);
# $ctx->stash('blog', $blog);
#
# if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
#     $ctx->_eval('?>' . $_var_compiled);
# } else {
#     print('Error compiling template module.');
# }
#
# ?>
# PHP
# }
#
# SKIP:
# {
#     unless ( join( '', `php --version 2>&1` ) =~ m/^php/i ) {
#         skip "Can't find executable file: php",
#             1 * blocks('expected_dynamic');
#     }
#
#     run {
#         my $block = shift;
#
#     SKIP:
#         {
#             skip $block->skip, 1 if $block->skip;
#
#             open2( my $php_in, my $php_out, 'php -q' );
#             print $php_out &php_test_script( $block->template, $block->text );
#             close $php_out;
#             my $php_result = do { local $/; <$php_in> };
#             $php_result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
#
#             my $name = $block->name . ' - dynamic';
#             is( $php_result, $block->expected, $name );
#         }
#     };
# }

__END__

=== MT::ContentField label="single line text"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="single line text"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
test single line text

=== MT::ContentField label="multi line text"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="multi line text"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
test multi line text
aaaaa

=== MT::ContentField label="number"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="number"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
12345

=== MT::ContentField label="url"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="url"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
https://example.com/~abby

=== MT::ContentField label="embed text"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="embed text"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
abc
def

=== MT::ContentField label="date and time"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="date and time"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
June  3, 2017  6:05 PM

=== MT::ContentField label="date and time" format_name="iso8601"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="date and time" format_name="iso8601"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
2017-06-03T18:05:00+00:00

=== MT::ContentField label="date"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="date"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
June  5, 2017

=== MT::ContentField label="date" format_name="iso8601"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="date" format_name="iso8601"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
2017-06-05T00:00:00+00:00

=== MT::ContentField label="time"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="time"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
12:34 PM

=== MT::ContentField label="time" format_name="iso8601"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="time" format_name="iso8601"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
1970-01-01T12:34:56+00:00

=== MT::ContentField label="select box"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="select box"><mt:var name="__key__">,<mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
def,2

=== MT::ContentField label="radio"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="radio"><mt:var name="__key__">,<mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
ghi,3

=== MT::ContentField label="checkbox"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="checkbox"><mt:var name="__key__">,<mt:var name="__value__">
</mt:ContentField></mt:Contents>
--- expected
abc,1
ghi,3

=== MT::ContentField label="list"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="list" glue=":"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
aaa:bbb:ccc

=== MT::ContentField label="table"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="table"><mt:var name="__value__"></mt:ContentField></mt:Contents>
--- expected
<table>
<tr><th></th><th>1</th><th>2</th><th>3</th></tr>
<tr><th>a</th><td>1</td><td></td><td></td></tr>
<tr><th>b</th><td></td><td>2</td><td></td></tr>
<tr><th>c</th><td></td><td></td><td>3</td></tr>
</table>
