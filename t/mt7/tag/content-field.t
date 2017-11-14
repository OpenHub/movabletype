#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

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
        my $cf_embedded_text = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'embedded text',
            type            => 'embedded_text',
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
            name            => 'date_only',
            type            => 'date_only',
        );
        my $cf_time = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'time_only',
            type            => 'time_only',
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
            name            => 'radio button',
            type            => 'radio_button',
        );
        my $cf_checkbox = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'checkboxes',
            type            => 'checkboxes',
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
            name            => 'tables',
            type            => 'tables',
        );
        my $cf_tag = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'tags',
            type            => 'tags',
        );
        my $tag1 = MT::Test::Permission->make_tag( name => 'tag1' );
        my $tag2 = MT::Test::Permission->make_tag( name => 'tag2' );

        my $cf_category = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'categories',
            type            => 'categories',
        );
        my $category_set = MT::Test::Permission->make_category_set(
            blog_id => $ct->blog_id,
            name    => 'test category set',
        );
        my $category1 = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category1',
        );
        my $category2 = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category2',
        );

        my $cf_image = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'asset_image',
            type            => 'asset_image',
        );
        my $image1 = MT::Test::Permission->make_asset(
            class     => 'image',
            blog_id   => $blog_id,
            url       => 'http://narnia.na/nana/images/test.jpg',
            file_path => File::Spec->catfile(
                $ENV{MT_HOME}, "t", 'images', 'test.jpg'
            ),
            file_name    => 'test.jpg',
            file_ext     => 'jpg',
            image_width  => 640,
            image_height => 480,
            mime_type    => 'image/jpeg',
            label        => 'Sample Image 1',
            description  => 'Sample photo',
        );
        my $image2 = MT::Test::Permission->make_asset(
            class     => 'image',
            blog_id   => $blog_id,
            url       => 'http://narnia.na/nana/images/test2.jpg',
            file_path => File::Spec->catfile(
                $ENV{MT_HOME}, "t", 'images', 'test2.jpg'
            ),
            file_name    => 'test2.jpg',
            file_ext     => 'jpg',
            image_width  => 640,
            image_height => 480,
            mime_type    => 'image/jpeg',
            label        => 'Sample Image 2',
            description  => 'Sample photo',
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
            {   id        => $cf_embedded_text->id,
                order     => 5,
                type      => $cf_embedded_text->type,
                options   => { label => $cf_embedded_text->name },
                unique_id => $cf_embedded_text->unique_id,
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
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
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
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
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
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
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
                    label        => $cf_table->name,
                    initial_row  => 3,
                    initial_cols => 3,
                },
            },
            {   id      => $cf_tag->id,
                order   => 14,
                type    => $cf_tag->type,
                options => {
                    label    => $cf_tag->name,
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                },
            },
            {   id      => $cf_category->id,
                order   => 15,
                type    => $cf_category->type,
                options => {
                    label        => $cf_category->name,
                    category_set => $category_set->id,
                    multiple     => 1,
                    max          => 5,
                    min          => 1,
                },
            },
            {   id      => $cf_image->id,
                order   => 16,
                type    => $cf_image->type,
                options => {
                    label    => $cf_image->name,
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                    multiple => 1,
                    max      => 5,
                    min      => 1,
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
                $cf_embedded_text->id    => "abc\ndef",
                $cf_datetime->id         => '20170603180500',
                $cf_date->id             => '20170605000000',
                $cf_time->id             => '19700101123456',
                $cf_select_box->id       => [2],
                $cf_radio->id            => [3],
                $cf_checkbox->id         => [ 1, 3 ],
                $cf_list->id             => [ 'aaa', 'bbb', 'ccc' ],
                $cf_table->id => "<tr><td>1</td><td></td><td></td></tr>\n"
                    . "<tr><td></td><td>2</td><td></td></tr>\n"
                    . "<tr><td></td><td></td><td>3</td></tr>",
                $cf_tag->id      => [ $tag2->id,      $tag1->id ],
                $cf_category->id => [ $category2->id, $category1->id ],
                $cf_image->id    => [ $image1->id,    $image2->id ],
            },
        );
    }
);

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== mt:ContentField label="single line text"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="single line text"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
test single line text
Footer

=== mt:ContentField label="multi line text"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="multi line text"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
test multi line text
aaaaa
Footer

=== mt:ContentField label="number"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="number"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
12345
Footer

=== mt:ContentField label="url"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="url"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
https://example.com/~abby
Footer

=== mt:ContentField label="embedded text"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="embedded text"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
abc
def
Footer

=== mt:ContentField label="date and time"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="date and time"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
June  3, 2017  6:05 PM
Footer

=== mt:ContentField label="date and time" format_name="iso8601"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="date and time"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue format_name="iso8601">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
2017-06-03T18:05:00+00:00
Footer

=== mt:ContentField label="date_only"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="date_only"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
June  5, 2017
Footer

=== mt:ContentField label="date_only" format_name="iso8601"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="date_only"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue format_name="iso8601">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
2017-06-05T00:00:00+00:00
Footer

=== mt:ContentField label="time_only"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="time_only"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
12:34 PM
Footer

=== mt:ContentField label="time_only" format_name="iso8601"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="time_only"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:ContentFieldValue format_name="iso8601">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
1970-01-01T12:34:56+00:00
Footer

=== mt:ContentField label="select box"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="select box"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__key__">,<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
def,2
Footer

=== mt:ContentField label="radio button"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="radio button"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__key__">,<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
ghi,3
Footer

=== mt:ContentField label="checkboxes"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="checkboxes"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__key__">,<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
abc,1

ghi,3
Footer

=== mt:ContentField label="list"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="list" glue=":"><mt:ContentFieldHeader>Header:</mt:ContentFieldHeader><mt:var name="__value__"><mt:ContentFieldFooter>:Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header:aaa:bbb:ccc:Footer

=== mt:ContentField label="tables"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="tables"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:var name="__value__">
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
<table>
<tr><td>1</td><td></td><td></td></tr>
<tr><td></td><td>2</td><td></td></tr>
<tr><td></td><td></td><td>3</td></tr>
</table>
Footer

=== mt:ContentField label="tags"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="tags"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:TagName>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
tag2

tag1
Footer

=== mt:ContentField label="categories"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="categories"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:CategoryLabel>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
category2

category1
Footer

=== mt:ContentField label="asset_image"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentField label="asset_image"><mt:ContentFieldHeader>Header</mt:ContentFieldHeader>
<mt:AssetLabel>
<mt:ContentFieldFooter>Footer</mt:ContentFieldFooter></mt:ContentField></mt:Contents>
--- expected
Header
Sample Image 1

Sample Image 2
Footer
