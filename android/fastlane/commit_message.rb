# commit messageの定義

$publish_message = Time.now.strftime('%Y-%m-%d %H:%M:%S')
value = `git rev-parse HEAD`
commit_message = `git rev-list --format=%B --max-count=1 #{value}`
ary_message = commit_message.lines

if ary_message.length > 1 then
    $publish_message = $publish_message.concat(" "+ary_message[1])
end
$publish_message2 = $publish_message.concat(" prod-debug")

#print $publish_message