redislua = (loadfile "redis.lua")()
redis  = redislua.connect('127.0.0.1', 6379)
serpent = (loadfile "serpent.lua")()
http = require("socket.http")
get = http.request
sudo = 477390880
bot = (SERVER-NUMBER -1) * ON-SERVER + BOT-ID
---------------Info---------------
if redis:scard('emoji') == 0 then
redis:sadd('emoji','\xF0\x9F\x98\x81')
redis:sadd('emoji','\xF0\x9F\x98\x82')
redis:sadd('emoji','\xF0\x9F\x98\x83')
redis:sadd('emoji','\xF0\x9F\x98\x84')
redis:sadd('emoji','\xF0\x9F\x98\x85')
redis:sadd('emoji','\xF0\x9F\x98\x86')
redis:sadd('emoji','\xF0\x9F\x98\x89')
redis:sadd('emoji','\xF0\x9F\x98\x8A')
redis:sadd('emoji','\xF0\x9F\x98\x8B')
redis:sadd('emoji','\xF0\x9F\x98\x8C')
redis:sadd('emoji','\xF0\x9F\x98\x8D')
redis:sadd('emoji','\xF0\x9F\x98\x8F')
redis:sadd('emoji','\xF0\x9F\x98\x92')
redis:sadd('emoji','\xF0\x9F\x98\x93')
redis:sadd('emoji','\xF0\x9F\x98\x94')
redis:sadd('emoji','\xF0\x9F\x98\x96')
redis:sadd('emoji','\xF0\x9F\x98\x98')
redis:sadd('emoji','\xF0\x9F\x98\x9A')
redis:sadd('emoji','\xF0\x9F\x98\x9C')
redis:sadd('emoji','\xF0\x9F\x98\x9D')
redis:sadd('emoji','\xF0\x9F\x98\x9E')
redis:sadd('emoji','\xF0\x9F\x98\xA0')
redis:sadd('emoji','\xF0\x9F\x98\xA1')
redis:sadd('emoji','\xF0\x9F\x98\xA2')
redis:sadd('emoji','\xF0\x9F\x98\xA3')
redis:sadd('emoji','\xF0\x9F\x98\xA4')
redis:sadd('emoji','\xF0\x9F\x98\xA5')
redis:sadd('emoji','\xF0\x9F\x98\xA8')
redis:sadd('emoji','\xF0\x9F\x98\xA9')
redis:sadd('emoji','\xF0\x9F\x98\xAA')
redis:sadd('emoji','\xF0\x9F\x98\xAB')
end
function varinfo()
if redis:get('botBOT-IDnum') then
local phone = "+"..redis:get('botBOT-IDnum')
local name = redis:get('botBOT-IDfname') .. " " redis:get('botBOT-IDlname')
usr = redis:get('botBOT-IDusername') or "none"
if user ~= "none" then
usr = "@"..usr
end
local id = redis:get('botBOT-IDid')
print("")
print("")

print("      Bot Info :")
print("      -> Account Phone Number : " .. phone)
print("      -> Account Full Name    : " .. name)
print("      -> Account Username     : " .. usr)
print("      -> Account ID           : " .. id)

print("")
print("")
else
print("")
print("")
print("      Bot Info Not Found!")
print("")
print("")

end
end
varinfo()
----------------------------------
function sleep(n)
  os.execute("sleep " .. tonumber(n))
end
function get_bot ()
function bot_info (i, purya)
  redis:set("botBOT-IDid", math.ceil(tonumber(purya.id)))
  if not redis:sismember("botBOT-IDadmin", math.ceil(tonumber(purya.id))) then
	redis:sadd("botBOT-IDadmin", math.ceil(tonumber(purya.id)))
  end
  if purya.first_name then
    redis:set("botBOT-IDfname", purya.first_name)
  end
  if purya.last_name then
    redis:set("botBOT-IDlname", purya.last_name)
  end
  if purya.username then
    redis:set("botBOT-IDusername", purya.username)
  end
  redis:set("botBOT-IDnum", purya.phone_number)
  return purya.id
end
assert (tdbot_function ({_ = "getMe"}, bot_info, nil))
end
function math.sign(v)
	return (v >= 0 and 1) or -1
end
function round(v, bracket)
	bracket = bracket or 1
	return math.floor(v/bracket + math.sign(v) * 0.5) * bracket
end

function checkisinforwardmode()
  local isforwardmode = redis:get('botBOT-IDfwd_isforwardmode') and 'yup' or 'nop'
  if(isforwardmode == 'yup') then
    local fwd_targetlistcount = redis:scard('botBOT-IDfwd_targetlist')
    if fwd_targetlistcount > 0 then
      local fwd_untilnext = redis:get('botBOT-IDfwd_untilnext') and redis:ttl('botBOT-IDfwd_untilnext') or 0
      if fwd_untilnext <= 0 then
        timingforward()
      end
    else
      local fwd_fromchatid = redis:get('botBOT-IDfwd_fromchatid')
      if fwd_fromchatid then
        local listcount =  redis:get('botBOT-IDfwd_listcount')
        redis:del('botBOT-IDfwd_targetlist')
        redis:del('botBOT-IDfwd_isforwardmode')
        redis:del('botBOT-IDfwd_listcount')
        redis:del('botBOT-IDfwd_delay')
        redis:del('botBOT-IDfwd_fromchatid')
        redis:del('botBOT-IDfwd_messageid')
        redis:del('botBOT-IDfwd_untilnext')
		if redis:get('botBOT-IDautoforward') then
			local fmsg = redis:get('botBOT-IDlastforward')
			local getmsg = redis:get('botBOT-IDmsg'..fmsg) or 0
			local msgplus = getmsg + 1
			redis:set('botBOT-IDmsg'..fmsg,msgplus)
		
		else
        send(fwd_fromchatid, 0, 'OK ,Im ready now ')
		end
	  end
    end
  end
end


function timingforwardcallback(data, purya)
  local fwd_chatid = data.fwd_chatid
  local fwd_fromchatid = data.fwd_fromchatid
  local fwd_delay_min = redis:get('botBOT-IDfwd_delay') - 1
  local fwd_delay_max = redis:get('botBOT-IDfwd_delay') + 2
  local fwd_delay = math.random(fwd_delay_min,fwd_delay_max)
  if purya._ == 'error' then
    if purya.code == 429 or purya.code == 429.0 then
      local message = tostring(purya.message)
      local floodTime = message:match('%d+')
      redis:setex('botBOT-IDfwd_untilnext', tonumber(floodTime) + tonumber(fwd_delay), true)
      return
    elseif purya.code == 400 or purya.code == 400.0 then
			  getChat(fwd_chatid, rem)
            assert (tdbot_function ({
              _ = "setChatMemberStatus",
              chat_id = tostring(fwd_chatid),
              user_id = tonumber(bot_id),
              status = {_ = "chatMemberStatusLeft"},
            }, dl_cb, nil))

    end
  end

if redis:sismember('botBOT-IDfwd_targetlist', fwd_chatid) then
  redis:srem('botBOT-IDfwd_targetlist', fwd_chatid)
end
redis:setex('botBOT-IDfwd_untilnext', tonumber(fwd_delay), true)
end


function timingforward()
local fwd_chatid = redis:srandmember('botBOT-IDfwd_targetlist')
local fwd_fromchatid = redis:get('botBOT-IDfwd_fromchatid')
local fwd_messageid = redis:get('botBOT-IDfwd_messageid')
local fwd_reapet = redis:get('botBOT-IDfwd_reapet')
	for S = 1, fwd_reapet, 1 do
		assert( tdbot_function({
		_ = "forwardMessages",
		chat_id = tonumber(fwd_chatid),
		from_chat_id = tonumber(fwd_fromchatid),
		message_ids = {[0] = tonumber(fwd_messageid)},
		disable_notification = true,
		from_background = true
		}, timingforwardcallback, {fwd_chatid = fwd_chatid, fwd_fromchatid = fwd_fromchatid}))
	end
end


function permanentforward(chat_id, from_chat_id, message_id)
assert( tdbot_function({
  _ = "forwardMessages",
  chat_id = tonumber(chat_id),
  from_chat_id = tonumber(from_chat_id),
  message_ids = {[0] = tonumber(message_id)},
  disable_notification = true,
  from_background = true
}, dl_cb, nil))
end


function forward(from_chat_id, message_id)
local isforwardmode = redis:get('botBOT-IDfwd_isforwardmode') and 'yup' or 'nop'
if(isforwardmode == 'yup') then
  if redis:get('botBOT-IDautoforward') then
  return
  else
  local fwd_targetlistcount = redis:scard('botBOT-IDfwd_targetlist')
  local fwd_delay = redis:get('botBOT-IDfwd_delay')
  local total = tonumber(fwd_targetlistcount) * tonumber(fwd_delay)
  send(from_chat_id, 0, 'ouch..! seems ' .. tostring(fwd_targetlistcount) .. ' forwards left, try about ' .. tostring(total) .. ' seconds again.' )
  return
  end
end


local list = redis:smembers('botBOT-IDsupergroups')
local listcount = redis:scard('botBOT-IDsupergroups')
local delay = redis:get('botBOT-IDdelay') or 2
local reapet = redis:get('botBOT-IDreapet') or 1
if not listcount or tonumber(listcount) == 0 then
  return
end
if not delay or tonumber(delay) == 0 then
for n, s in pairs(list) do
	for S = 1, reapet, 1 do
    permanentforward(s, from_chat_id, message_id)
	end
  end
  	if not redis:get('botBOT-IDautoforward') then
		send(from_chat_id, 0, 'OK,Fordadam be ' .. tostring(listcount) .. ' Supergroups Va Pv' )
	end
  return
end
local esttime = tonumber(delay) * tonumber(listcount)
if not redis:get('botBOT-IDautoforward') then
	send(from_chat_id, 0, 'plz wait '.. tostring(esttime) .. 's '..redis:srandmember('emoji'))
end
for i, v in pairs(list) do
  redis:sadd('botBOT-IDfwd_targetlist', v)
end

redis:set('botBOT-IDfwd_isforwardmode', 'yup')
redis:set('botBOT-IDfwd_listcount', tonumber(listcount))
redis:set('botBOT-IDfwd_delay', tonumber(delay))
redis:set('botBOT-IDfwd_reapet', tonumber(reapet))
redis:set('botBOT-IDfwd_fromchatid', tonumber(from_chat_id))
redis:set('botBOT-IDfwd_messageid', tonumber(message_id))
redis:setex('botBOT-IDfwd_untilnext', tonumber(delay), true)
end


function dl_cb(arg, data)
end

function vardump(value)
print(serpent.block(value, {comment=false}))
end

function is_purya(msg)
if redis:sismember("botBOT-IDadmin",math.ceil(tonumber(msg.sender_user_id))) or msg.sender_user_id == sudo then
  return true
else
  return false
end
end

function writefile(filename, input)
local file = io.open(filename, "w")
file:write(input)
file:flush()
file:close()
return true
end
function process_join(i, purya)
if purya.code == 429 then
  local message = tostring(purya.message)
  local floodTime = message:match('%d+')
  local join_delay = redis:get("botBOT-IDjoindelay") or math.random(90,100)
  local Time = tonumber(floodTime) + tonumber(join_delay)
  redis:setex("botBOT-IDmaxjoin", tonumber(Time), true)
elseif purya._ == "ok" then
  redis:srem("botBOT-IDgoodlinks", i.link)
  redis:sadd("botBOT-IDsavedlinks", i.link)
  
else
    redis:setex("botBOT-IDmaxjoin", 50, true)

end
end


function process_left(i, purya)
if purya._ == "ok" then
	redis:srem("botBOT-IDsupergroups", i.gp)
	redis:srem("botBOT-IDall", i.gp)
	
elseif purya.code == 429 then
  local message = tostring(purya.message)
  local floodTime = message:match('%d+')
  local left_delay = redis:get("botBOT-IDautoleftdelay") or 10
  local Time = tonumber(floodTime) + tonumber(left_delay)
  redis:setex("botBOT-IDmaxleft", tonumber(Time), true)
else
   redis:srem("botBOT-IDsupergroups", i.gp)
   redis:srem("botBOT-IDall", i.gp)
   
  end
end
function refresh(i, purya)
if purya._ == 'error' or purya.status._ == 'chatMemberStatusLeft' then
  redis:srem("botBOT-IDsupergroups", i.list)
  redis:srem("botBOT-IDall", i.list)
  
elseif purya.status._ == 'chatMemberStatusMember' then
  
end
end
function find_link(text,chat_id)
if text:match("https://telegram.me/joinchat/%S+") or text:match("https://t.me/joinchat/%S+") or text:match("t.me/joinchat/%S+") or text:match("telegram.me/joinchat/%S+") or text:match("http://telegram.me/joinchat/%S+") or text:match("http://t.me/joinchat/%S+") or text:match("https://telegram.dog/joinchat/%S+") then
  local text = text:gsub("t.me", "https://telegram.me")
  local text = text:gsub("telegram.dog", "https://telegram.me")
  local unionlinks = redis:sunionstore("botBOT-IDunionlinks",'botBOT-IDsavedlinks','botBOT-IDgoodlinks','botBOT-IDwaitelinks')
	for link in text:gmatch("(https://telegram.me/joinchat/%S+)") do
    if not redis:sismember("botBOT-IDunionlinks", link) then
      redis:sadd("botBOT-IDwaitelinks", link)
	 redis:setex("botBOT-IDmaxlink", 10, true)
	  end
  end
  redis:del("botBOT-IDunionlinks")
 end
end
function openChat(chatid)
  assert (tdbot_function ({
    _ = 'openChat',
    chat_id = chatid
  },dl_cb, nil))
end

function getChat(chatid, callback)
  assert (tdbot_function ({
    _ = 'getChat',
    chat_id = chatid
  }, callback, nil))
end

function add(i, purya)
local id = tostring(purya.id)

if not redis:sismember("botBOT-IDall", id) then

	if purya.type._ == "chatTypeSupergroup" and purya.type.is_channel == false then
			redis:sadd("botBOT-IDall", id)
			redis:sadd("botBOT-IDsupergroups", id)
		
	elseif purya.type._ == "chatTypePrivate" then
		redis:sadd("botBOT-IDusers", id)
		redis:sadd("botBOT-IDall", id)
	end

end
end
function rem(i, purya)
local id = tostring(purya.id)
if redis:sismember("botBOT-IDall", id) then

	if purya.type._ == "chatTypeSupergroup" and purya.type.is_channel == false then
		redis:srem("botBOT-IDsupergroups", id)
		redis:srem("botBOT-IDall", id)
		
	elseif purya.type._ == "chatTypePrivate" then
		redis:srem("botBOT-IDusers", id)
		redis:srem("botBOT-IDall", id)
	end
end
end

function send(chat_id, msg_id, txt, parse)
assert (tdbot_function ({
  _ = "sendChatAction",
  chat_id = chat_id,
  action = {
    _ = "chatActionTyping",
    progress = 200
  }
}, dl_cb, nil))



sleep(math.random(1,3))
assert (tdbot_function ({
  _ = "sendMessage",
  chat_id = chat_id,
  reply_to_message_id = msg_id,
  disable_notification=false,
  from_background=true,
  reply_markup=nil,
  input_message_content={
    _="inputMessageText",
    text= txt,
    disable_web_page_preview=true,
    clear_draft=false,
    entities={},
    parse_mode=parse}
  }, dl_cb, nil))
end
function randomtext()


		  local Chars = {}
for Loop = 0, 255 do
   Chars[Loop+1] = string.char(Loop)
end
local String = table.concat(Chars)

local Built = {['.'] = Chars}

local AddLookup = function(CharSet)
   local Substitute = string.gsub(String, '[^'..CharSet..']', '')
   local Lookup = {}
   for Loop = 1, string.len(Substitute) do
       Lookup[Loop] = string.sub(Substitute, Loop, Loop)
   end
   Built[CharSet] = Lookup

   return Lookup
end
				  local function rands(Length, CharSet)
		   -- Length (number)
		   -- CharSet (string, optional); e.g. %l%d for lower case letters and digits

		   local CharSet = CharSet or '.'

		   if CharSet == '' then
			  return ''
		   else
			  local Result = {}
			  local Lookup = Built[CharSet] or AddLookup(CharSet)
			  local Range = #Lookup

			  for Loop = 1,Length do
				 Result[Loop] = Lookup[math.random(1, Range)]
			  end

			  return table.concat(Result)
		   end
		end
		local ran1 = rands(math.random(3,7),'abcdefghijklmnopqrstuvwxyz')
		local ran2 = rands(math.random(2,3),'abcdefghijklmnopqrstuvwxyz')
		local ran3 = rands(math.random(5,6),'abcdefghijklmnopqrstuvwxyz')
		local ran4 = rands(math.random(3,4),'abcdefghijklmnopqrstuvwxyz')
		local ran5 = rands(1,'.?!')
		local ran6 = rands(math.random(1,4),'😀😃😄😁😆😅😂🤣☺️😊😇🙂🙃😉😌😍😘😗😙😚😋😜😝😛🤗🤑🤓😎🤡🤠😏😒😞😔😟😕🙁☹️😣😖😫😩😤😠😡😶😐😑😯😦😧😮😲😵😳😱😨😰😢😥🤤😭😓😪😴🙄🤔🤥😬🤐🤢🤧😷🤒🤕😈👿😼😽🙀😿😾😻😹😸😺👐🏻🙌🏽👏🏾🙏🏼🤝👍👎🏽👊🏻✊️🤘🏼👌👌🏾👈🏻👋🏻🤙🏻')
		return ran1 .. " " .. ran2 .. " " .. ran3 .. " " .. ran4 .. " " .. ran5 .. redis:srandmember('emoji') .. redis:srandmember('emoji')
		
end
function test (i,purya)

vardump("---------------------------------")
vardump(purya)


vardump("---------------------------------")
end
function edit(chat, msg, txt, parse)
assert (tdbot_function ({
    _ = 'editMessageText',
    chat_id = chat,
    message_id = msg,
    reply_markup = nil,
    input_message_content = {
      _ = 'inputMessageText',
      text = txt,
      disable_web_page_preview = true,
      clear_draft = false,
      entities = {},
      parse_mode = parse}
  }, callback or dl_cb, data))
end
function tdbot_update_callback (data)
  if (data._ == "updateNewMessage") then
	local msg = data.message
if not redis:get("botBOT-IDjointurnedoff") then
  if redis:scard("botBOT-IDsupergroups") >= 455 then
	 redis:set("botBOT-IDmaxjoin", true)
     redis:set("botBOT-IDoffjoin", true)
	 redis:set("botBOT-IDjointurnedoff", true)
  end
  
else

  if redis:scard("botBOT-IDsupergroups") <= 454 then
	 redis:del("botBOT-IDmaxjoin")
     redis:del("botBOT-IDoffjoin")
	 redis:del("botBOT-IDjointurnedoff")
  end
  
  
end
  
    if not redis:get("botBOT-IDmaxlink") then
      if redis:scard("botBOT-IDwaitelinks") ~= 0 then        
		local links = redis:smembers("botBOT-IDwaitelinks")
        for x = 1, #links do
          local source = get(links[x])
		  local linktype = source:match'  <a class="tgme_action_button_new" href="tg://join[?]invite=.*">(.-)</a>'
		  if linktype == "Join Group" then
		  local title = source:match'<meta property="og:title" content="(.-)"'  	
		  if title ~= 'Join group chat on Telegram' then 
			
		  local isSupergroup = false
		  if redis:get("botBOT-IDleftad") then
			local banlist = redis:smembers("botBOT-IDbanlist")
			for x = 1, #banlist do
				if title:find(tostring(banlist[x])) or title:find(banlist[x]) then
				 isSupergroup = false
				 break
				else
				isSupergroup = true
				end
		  end
	      else
			isSupergroup = true
		  end
		  if source:find('tgme_page_extra') then
			 member_count = string.gsub(source:match'<div class="tgme_page_extra">(.-)members</div>' or source:match'<div class="tgme_page_extra">(.-)member</div>', "%s+", "")
						member_count = tonumber(member_count:match('%d+'))
			if member_count == nil then 
					  isSupergroup = false

			end
		 else
		  
		  isSupergroup = false
		  end
		  if isSupergroup == true then
				if redis:get('botBOT-IDgpmmbr') then
				local minmember = tonumber(redis:get('botBOT-IDmingpmmbr')) or 1
				local maxmember = tonumber(redis:get('botBOT-IDmaxgpmmbr')) or 999999
				if member_count >= minmember and member_count <= tonumber(redis:get('botBOT-IDmaxgpmmbr')) then
				redis:srem("botBOT-IDwaitelinks", links[x])
				redis:sadd("botBOT-IDgoodlinks", links[x])
				else
				  redis:srem("botBOT-IDwaitelinks", links[x])
				end
			  else
			  

				redis:srem("botBOT-IDwaitelinks", links[x])
				redis:sadd("botBOT-IDgoodlinks", links[x])
			  end

			else

			  redis:srem("botBOT-IDwaitelinks", links[x])

			end
		  else 
		  end
		  else
			redis:sadd('channel',links[x])
		  redis:srem("botBOT-IDwaitelinks",links[x])
		  end
          if x == 60 then 
		  redis:setex("botBOT-IDmaxlink", 60, true)
		  return
		  end
        end
	  end
    end
     if not redis:get("botBOT-IDmaxjoin") then
      if redis:scard("botBOT-IDgoodlinks") ~= 0 then
        local link = redis:srandmember("botBOT-IDgoodlinks")
        local delay = math.random(305,380)

		assert (tdbot_function ({
		_ = 'checkChatInviteLink',
		invite_link = tostring(link)
		},function(i,purya)

			if purya.code == 429 then

				local message = tostring(purya.message)
				local floodTime = message:match('%d+')
				local join_delay = redis:get("botBOT-IDjoindelay") or math.random(90,100)
				local Time = tonumber(floodTime) + tonumber(join_delay)
				redis:setex("botBOT-IDmaxjoin", tonumber(Time), true)
			elseif purya.code == 400 then
								  redis:srem("botBOT-IDgoodlinks", link)
			elseif purya.type._ == "chatTypeSupergroup" and purya.type.is_channel == false then 
				sleep(math.random(4,8))
				assert (tdbot_function({
				_ = 'joinChatByInviteLink',
				invite_link = tostring(link)
				},process_join, {link=link}))
			else 
			  redis:srem("botBOT-IDgoodlinks", link)
			end
		end, nil))
         

	redis:setex("botBOT-IDmaxjoin", tonumber(delay), true) 

      end
    end
    
    
	bot_id = redis:get("botBOT-IDid") or get_bot()


	if redis:get('botBOT-IDautoleft') then
		if not redis:get('botBOT-IDmaxleft') then
		if redis:scard("botBOT-IDsupergroups") ~= 0 then
		local gps = redis:smembers("botBOT-IDsupergroups")
		local delay = redis:get("botBOT-IDautoleftdelay") or 10
		for x = 1, #gps do
		assert (tdbot_function ({
              _ = 'setChatMemberStatus',
              chat_id = tonumber(gps[x]),
              user_id = tonumber(bot_id),
              status = {_ = 'chatMemberStatusLeft'},
            }, process_left, {gp=gps[x]}))
          if x == 1 then 
		  redis:setex("botBOT-IDmaxleft", tonumber(delay), true)
		  return
		  end
        end
		end
		end
	end

	if not redis:sismember("botBOT-IDall", msg.chat_id) then
    getChat(msg.chat_id, add)
	
    end

	
    checkisinforwardmode()
	if redis:get('botBOT-IDautoforward') then
		if not redis:get('botBOT-IDmaxforward') then
		if redis:scard("botBOT-IDfmsg") ~= 0 then
		local min_delay = redis:get("botBOT-IDautoforwarddelay") - math.random(50,180)
		local max_delay = redis:get("botBOT-IDautoforwarddelay") + math.random(30,150)
		local delay = math.random(min_delay,max_delay)
		local fchat = redis:get("botBOT-IDfchat")
		fomsg = redis:srandmember("botBOT-IDfmsg")
		lastf = redis:get("botBOT-IDlastforward") or 0
		if fomsg == lastf then
		for i = 1,100,1 do
			   fomsg = redis:srandmember("botBOT-IDfmsg")
				if fomsg ~= lastf then
				break
				end
		end
		end
		redis:set("botBOT-IDlastforward",fomsg)
		forward(fchat,fomsg)
		redis:setex("botBOT-IDmaxforward", tonumber(delay), true)
		end
		end
	end

	if msg.date < os.time() - 150 then
      return false
    end
	if msg.content._ == "messageText" then
      local text = msg.content.text
      local matches
      if redis:get("botBOT-IDlink") then
        find_link(text)
      end
		local ci = tostring(msg.chat_id)
	  	if ci:match("^(%d+)$") then
			chat_type = 'user'
		elseif ci:match("^-100") then
			chat_type = 'super'
		else
			chat_type = 'group'
		end
		local Id = tostring(math.ceil(msg.chat_id))
    if chat_type == 'group' or chat_type == 'user' then
      local verify = is_purya(msg)
	  if verify == true then
        find_link(text,msg.chat_id)
        if text:match("^(dl)$") then
          redis:del("botBOT-IDgoodlinks")
          redis:del("botBOT-IDwaitelinks")
          redis:del("botBOT-IDsavedlinks")
          redis:del("botBOT-IDalllinks")
		           
  return send(msg.chat_id, 0, randomtext())
		elseif text:match("^(ll)$") then
					local list =  redis:smembers("botBOT-IDsavedlinks")
					for i=1, #list do
						text = tostring(text) .. tostring(list[i]).."\n"
					end
					writefile("ListLink.txt", text)
					assert (tdbot_function ({
						_ = 'sendMessage',
						chat_id = msg.chat_id,
						reply_to_message_id = 0,
						disable_notification = 0,
						from_background = 1,
						reply_markup = nil,
						input_message_content = {
						_ = 'inputMessageDocument',
						document = {_ = 'inputFileLocal', path = "ListLinkNMS.txt"},
					  }
					  }, dl_cb, nil))
			return io.popen("rm -rf ListLink.txt"):read("*all")
        elseif text:match("^(stp)(.*)$") then
          local matches = text:match("^stp(.*)$")
          if matches == "j" then
            redis:set("botBOT-IDmaxjoin", true)
            redis:set("botBOT-IDoffjoin", true)
            return send(msg.chat_id, 0, randomtext())
          elseif matches == "answer" then
		  	redis:del('botBOT-IDanswer')
            return send(msg.chat_id, 0, randomtext())

          elseif matches == "a" then
            redis:set("botBOT-IDmaxlink", true)
            redis:set("botBOT-IDofflink", true)
            return send(msg.chat_id, 0, randomtext())
          elseif matches == "f" then
            redis:del("botBOT-IDlink")
            return send(msg.chat_id, 0, randomtext())
		elseif matches == "jch" then
			redis:del("botBOT-IDjoinchannel")
            return send(msg.chat_id, 0, randomtext())
          end
        elseif text:match("^(s)(.*)$") then
          local matches = text:match("^s(.*)$")
          if matches == "j" then
            redis:del("botBOT-IDmaxjoin")
            redis:del("botBOT-IDoffjoin")
            return send(msg.chat_id, 0, randomtext())
          elseif matches == "answer" then
		  	redis:set('botBOT-IDanswer', true)
            return send(msg.chat_id, 0, "Done")

          elseif matches == "a" then
            redis:del("botBOT-IDmaxlink")
            redis:del("botBOT-IDofflink")
            return send(msg.chat_id, 0, randomtext())
          elseif matches == "f" then
            redis:set("botBOT-IDlink", true)
            return send(msg.chat_id, 0, randomtext())
		  elseif matches == "jch" then
			redis:set("botBOT-IDjoinchannel", true)
            return send(msg.chat_id, 0, randomtext())
          end
		  elseif text:match("^b (.*)") then 
			local matches = text:match('^b (.*)')
				assert (tdbot_function ({
				_ = 'setBio',
				bio = tostring(matches)
			  }, dl_cb, nil))
		elseif text:match("^m1 (.*)") then 
			local matches = text:match('^msg1 (.*)')
			redis:set('botBOT-IDfirstmsg',matches)
			send(msg.chat_id, 0, randomtext())
		elseif text:match("^m2 (.*)") then 
			local matches = text:match('^msg2 (.*)')
			redis:set('botBOT-IDsecondmsg',matches)
			send(msg.chat_id, 0, randomtext())
		elseif text:match("^m3 (.*)") then 
			local matches = text:match('^msg3 (.*)')
			redis:set('botBOT-IDthirdmsg',matches)
			send(msg.chat_id, 0, randomtext())
		elseif text:match("^j (.*)") then 
		
				  	local link = text:match('^j (.*)')
			assert (tdbot_function({
            _ = 'joinChatByInviteLink',
            invite_link = tostring(link)
          },dl_cb, nil))
		  elseif text:match("^(ab) (.*)$") then
          local matches = text:match("^ab (.*)$") 
		  redis:sadd('botBOT-IDbanlist', tostring(matches))
		  redis:set('botBOT-IDleftad', true)
		  local list = redis:smembers('botBOT-IDbanlist')
		  local text = ' "'..tostring(matches).. randomtext() ..' : \n'
			for i, v in pairs(list) do
				text = tostring(text) .. tostring(i) .. " - " .. tostring(v).."\n"
			end
		  send(msg.chat_id, 0, text)
		  elseif text:match("^(admin) (%d+)$") then
          local matches = text:match("%d+")
          if not redis:sismember('botBOT-IDadmin',tonumber(matches)) then
            redis:sadd('botBOT-IDadmin', tonumber(matches))
			local list = redis:smembers('botBOT-IDadmin')
			local text = ' "'..tostring(matches).. randomtext() ..' : \n'
			for i, v in pairs(list) do
				text = tostring(text) .. tostring(i) .. " - " .. tostring(v).."\n"
			end
		  send(msg.chat_id, 0, text)
		  else
			send(msg.chat_id, 0, randomtext())
          end

		elseif text:match("^([Cc]p)$") then
			for i,v in pairs(redis:smembers('botBOT-IDfmsg')) do
			redis:del('botBOT-IDmsg'..v)
			end
		redis:del('botBOT-IDfmsg')
		elseif text:match("^(gp)$") then
		local fchat = redis:get('botBOT-IDfchat')
		for i,v in pairs(redis:smembers('botBOT-IDfmsg')) do
		assert( tdbot_function({
  _ = "forwardMessages",
  chat_id = tonumber(msg.chat_id),
  from_chat_id = tonumber(fchat),
  message_ids = {[0] = tonumber(v)},
  disable_notification = true,
  from_background = true
}, dl_cb, nil))
		end
        elseif text:match("^(ca)$") then
          redis:del('botBOT-IDadmin')
          return send(msg.chat_id, 0, randomtext())
		elseif text:match("^(cb)$") then
          redis:del('botBOT-IDbanlist')
		  redis:del('botBOT-IDleftad')
          return send(msg.chat_id, 0, randomtext())
		elseif text:match("^(d) (%d+)$") then
          local matches = text:match("%d+")
          redis:set('botBOT-IDdelay', tonumber(matches))
          return send(msg.chat_id, 0, randomtext())
		elseif text:match("^(r) (%d+)$") then
          local matches = text:match("%d+")
          redis:set('botBOT-IDreapet', tonumber(matches))
          return send(msg.chat_id, 0, randomtext())
		elseif text:match("^(fd) (%d+)$") then
          local matches = text:match("%d+")
          redis:set('botBOT-IDautoforwarddelay', tonumber(matches))
          return send(msg.chat_id, 0, randomtext())
        elseif text:match("^(min) (%d+)$") then
          local matches = text:match("%d+")
			if matches == "0" then
				if not redis:get('botBOT-IDmaxgpmmbr') then redis:del('botBOT-IDgpmmbr') end 
			    redis:del('botBOT-IDmingpmmbr')
				send(msg.chat_id,0, randomtext())
		  else
				redis:set('botBOT-IDgpmmbr', true)
				redis:set('botBOT-IDmingpmmbr', tonumber(matches))
		   		send(msg.chat_id,0, randomtext())

			end
	    elseif text:match("^(max) (%d+)$") then
          local matches = text:match("%d+")
          if matches == "0" then
				if not redis:get('botBOT-IDmingpmmbr') then redis:del('botBOT-IDgpmmbr') end 
				redis:del('botBOT-IDmaxgpmmbr')
				send(msg.chat_id,0, randomtext())
		  else
				redis:set('botBOT-IDgpmmbr', true)
				redis:set('botBOT-IDmaxgpmmbr', tonumber(matches))
		   		send(msg.chat_id,0, randomtext())

			end
		elseif text:match("^(d)$") then
		    redis:set('botBOT-IDmingpmmbr', 100)
			redis:set('botBOT-IDmaxgpmmbr', 999999)
			redis:set('botBOT-IDgpmmbr', true)
			redis:set('botBOT-IDdelay', 2)
		    redis:set('botBOT-IDreapet', 1)
			redis:set('botBOT-IDleftad', true)
			redis:sadd('botBOT-IDbanlist', "بازدید")
			redis:sadd('botBOT-IDbanlist', "شارژ")
			redis:sadd('botBOT-IDbanlist', "ویو")
			redis:sadd('botBOT-IDbanlist', "Link")
		    redis:sadd('botBOT-IDbanlist', "link")
			redis:sadd('botBOT-IDbanlist', "بازار")
			redis:sadd('botBOT-IDbanlist', "آگهی")
			redis:sadd('botBOT-IDbanlist', "Tab")
			redis:sadd('botBOT-IDbanlist', "seen")
			redis:sadd('botBOT-IDbanlist', "تبلیغ")
			redis:sadd('botBOT-IDbanlist', "نیاز")
			redis:sadd('botBOT-IDbanlist', "سین")
			redis:sadd('botBOT-IDbanlist', "لینک")
			redis:sadd('botBOT-IDbanlist', "گسترده")
			redis:sadd('botBOT-IDbanlist', "تجارت")
			redis:sadd('botBOT-IDbanlist', "کانون")
			redis:sadd('botBOT-IDbanlist', "تبادل")
			redis:sadd('botBOT-IDbanlist', "خرید")
			redis:sadd('botBOT-IDbanlist', "tab")
			redis:sadd('botBOT-IDbanlist', "فروش")
		send(msg.chat_id, 0, randomtext())
		elseif text:match("^([Rr])$")then
          local list = redis:smembers("botBOT-IDsupergroups")
          for x = 1, #list do

            assert (tdbot_function ({
              _ = 'getChatMember',
              chat_id = tonumber(list[x]),
              user_id = tonumber(bot_id),
            },refresh , {list=list[x]}))

          end
          return send(msg.chat_id, 0, randomtext())
        elseif text:match("^([Pp]l)$") then
		  local autofwd = redis:get('botBOT-IDautoforward') and "✅️" or "⛔️"
		  local autofwdtime1 = redis:get("botBOT-IDautoforward") and redis:ttl("botBOT-IDautoforward") or 0
		  local autofwdtime = tonumber(autofwdtime1) / 60
		  local afd1 = redis:get('botBOT-IDautoforwarddelay') or 0
		  local afd = tonumber(afd1) / 60
          local naf = redis:get("botBOT-IDmaxforward") and redis:ttl("botBOT-IDmaxforward") or 0
		  local isfwd = redis:get('botBOT-IDfwd_isforwardmode') and "✅️" or "⛔️"
		  local fwd_targetlistcount = redis:scard('botBOT-IDfwd_targetlist') or "0"
		  local fwd_delay = redis:get('botBOT-IDfwd_delay') or "0"
		  local total = tonumber(fwd_targetlistcount) * tonumber(fwd_delay)
          local offjoin = redis:get("botBOT-IDoffjoin") and "⛔️" or "✅️"
          local offlink = redis:get("botBOT-IDofflink") and "⛔️" or "✅️"

          local nlink = redis:get("botBOT-IDlink") and "✅️" or "⛔️"
		  local fwdd = redis:get('botBOT-IDdelay') or 2
		  local fwdr = redis:get('botBOT-IDreapet') or 1
		  local fmsg = ""
		  for i,v in pairs(redis:smembers('botBOT-IDfmsg')) do
		  local times = math.ceil(redis:get('botBOT-IDmsg'..v)) or 0

			fmsg = fmsg .. i .. ". "..v .. "        ".. tonumber(times) .. " t".. "\n"
		  end
		  local fchat = redis:get('botBOT-IDfchat') or "-"
          local nowf = redis:get('botBOT-IDlastforward') or "-"
		  local text = [[B]]..bot.. [[ j(]]..tostring(offjoin).. [[) - a(]] .. tostring(offlink) .. [[) - f(]] .. tostring(nlink) ..[[)
		  
af : ]]..tostring(autofwd)..[[ f ]] .. round(autofwdtime, 0.1) .. [[ m
fd : ]].. math.ceil(afd) ..[[ m
nf : ]] .. math.ceil(naf) ..[[ s
fs : ]] ..tostring(fchat)..[[
fp : 
]] ..tostring(fmsg)..[[
dbf : ]]..tostring(fwdd).. [[
fr: ]]..tostring(fwdr).. [[
is f ? : ]]..tostring(isfwd).. [[ - ]]..tonumber(fwd_targetlistcount)..[[ - and ]]..tonumber(total)..[[ s	
lf : ]]..tostring(nowf)

        return send(msg.chat_id,0, text, {_ = 'textParseModeMarkdown'})
        elseif text:match("^([Ii]nf)$") then
          local join =  redis:get("botBOT-IDoffjoin") and 0 or redis:get("botBOT-IDmaxjoin") and redis:ttl("botBOT-IDmaxjoin") or 0
          local accept = redis:get("botBOT-IDofflink") and 0 or redis:get("botBOT-IDmaxlink") and redis:ttl("botBOT-IDmaxlink") or 0
          local sgps = redis:scard("botBOT-IDsupergroups")
          local usrs = redis:scard("botBOT-IDusers")
		  local links = redis:scard("botBOT-IDsavedlinks")
          local glinks = redis:scard("botBOT-IDgoodlinks")
          local wlinks = redis:scard("botBOT-IDwaitelinks")
		  local mmbrs = redis:get("botBOT-IDmingpmmbr") or "0"
		  local maxmbrs = redis:get("botBOT-IDmaxgpmmbr") or "0"
		  
          local text = [[B]]..bot.. [[ :
		  
Sgps : ]].. tostring(sgps) ..[[
U : ]].. tostring(usrs) ..[[
l to j: ]].. tostring(glinks) ..[[
n j ]].. tostring(join) ..[[ s
l to a : ]].. tostring(wlinks) ..[[
n a ]].. tostring(accept) ..[[ s
s l : ]].. tostring(links)
        return send(msg.chat_id,0, text, {_ = 'textParseModeMarkdown'})
       
		elseif (text:match("^([Ss]p)$") and msg.reply_to_message_id ~= 0) then
		redis:sadd("botBOT-IDfmsg",math.ceil(tonumber(msg.reply_to_message_id)))
		redis:set("botBOT-IDmsg"..math.ceil(tonumber(msg.reply_to_message_id)), 0)
		redis:set("botBOT-IDfchat",math.ceil(tonumber(msg.chat_id)))
        elseif (text:match("^([Ff]da)$") and msg.reply_to_message_id ~= 0) then
		if redis:get('botBOT-IDautoforward') then
		send(msg.chat_id, 0, "no " .. randomtext())
		else 
		forward(math.ceil(tonumber(msg.chat_id)), math.ceil(tonumber(msg.reply_to_message_id)))
		end 
		elseif text:match("^([Aa]f) (%d+)$") then
          local matches = text:match("%d+")        
		  if matches == "0" then
		  	redis:del('botBOT-IDautoforward') 
			send(msg.chat_id,0, randomtext())
		  else
			redis:setex('botBOT-IDautoforward', tonumber(matches),true)
					send(msg.chat_id,0, randomtext())

		  end
		elseif text:match("^([Cc]f)$") then
          redis:del('botBOT-IDfwd_targetlist')
          redis:del('botBOT-IDfwd_isforwardmode')
          redis:del('botBOT-IDfwd_listcount')
          redis:del('botBOT-IDfwd_delay')
		  redis:del('botBOT-IDfwd_reapet')
          redis:del('botBOT-IDfwd_fromchatid')
          redis:del('botBOT-IDfwd_messageid')
          redis:del('botBOT-IDfwd_untilnext')
          send(msg.chat_id, 0, 'ғwd cαɴceled!')

        elseif text:match("^([Ll]a)$") then
		  local list = redis:smembers("botBOT-IDsupergroups")
          for i,v in pairs(list) do
            assert (tdbot_function ({
              _ = 'setChatMemberStatus',
              chat_id = tonumber(v),
              user_id = tonumber(bot_id),
              status = {_ = 'chatMemberStatusLeft'},
            }, dl_cb, nil))
			
          end
		  send(msg.chat_id,0, randomtext())
		  elseif text:match("^([Aa]l) (%d+)$") then
          local matches = text:match("%d+")        
		  if matches == "0" then
		  	redis:del('botBOT-IDautoleft') 
			send(msg.chat_id,0, randomtext())
		  else
			redis:set('botBOT-IDautoleft', true)
			redis:set('botBOT-IDautoleftdelay', tonumber(matches))
			send(msg.chat_id,0, randomtext())
		  end
		  elseif text:match("^([Aa]dd all) (%d+)$") then
          local matches = text:match("%d+")

          local list = redis:smembers("botBOT-IDsupergroups")
          for x = 1,#list do
            assert (tdbot_function({
              _ = "addChatMember",
              chat_id = tonumber(list[x]),
              user_id = tonumber(matches),
              forward_limit = 0
            }, dl_cb, nil))
          end
          send(msg.chat_id, 0, randomtext())
        elseif (text:match("^([Pp]g)$") and not msg.forward_info)then
          return assert (tdbot_function({
            _ = "forwardMessages",
            chat_id = msg.chat_id,
            from_chat_id = msg.chat_id,
            message_ids = {[0] = msg.id},
            disable_notification = 0,
            from_background = 1
          }, dl_cb, nil))
		  elseif text:match("^(p)(.*)$") or text:match("^(c)(.*)$") or text:match("^(k)(.*)$") then
		  local Chars = {}
for Loop = 0, 255 do
   Chars[Loop+1] = string.char(Loop)
end
local String = table.concat(Chars)

local Built = {['.'] = Chars}

local AddLookup = function(CharSet)
   local Substitute = string.gsub(String, '[^'..CharSet..']', '')
   local Lookup = {}
   for Loop = 1, string.len(Substitute) do
       Lookup[Loop] = string.sub(Substitute, Loop, Loop)
   end
   Built[CharSet] = Lookup

   return Lookup
end
				  local function rands(Length, CharSet)
		   -- Length (number)
		   -- CharSet (string, optional); e.g. %l%d for lower case letters and digits

		   local CharSet = CharSet or '.'

		   if CharSet == '' then
			  return ''
		   else
			  local Result = {}
			  local Lookup = Built[CharSet] or AddLookup(CharSet)
			  local Range = #Lookup

			  for Loop = 1,Length do
				 Result[Loop] = Lookup[math.random(1, Range)]
			  end

			  return table.concat(Result)
		   end
		end
		local ran1 = rands(math.random(3,7),'abcdefghijklmnopqrstuvwxyz')
				local ran2 = rands(math.random(2,3),'abcdefghijklmnopqrstuvwxyz')
						local ran3 = rands(math.random(5,6),'abcdefghijklmnopqrstuvwxyz')
								local ran4 = rands(math.random(3,4),'abcdefghijklmnopqrstuvwxyz')
local ran5 = rands(1,'. ? !')


			
		  send(msg.chat_id,0, ran1..' '..ran2..' '..ran3..' '..ran4..ran5)

        elseif text:match("^(he333lp)$") then
          local txt = '📍راهنمای دستورات تبلیغ‌گر📍\n\nانلاین\n<i>اعلام وضعیت تبلیغ‌گر ✔️</i>\n<code>❤️ حتی اگر تبلیغ‌گر شما دچار محدودیت ارسال پیام شده باشد بایستی به این پیام پاسخ دهد❤️</code>\n\nافزودن مدیر شناسه\n<i>افزودن مدیر جدید با شناسه عددی داده شده 🛂</i>\n\nافزودن مدیرکل شناسه\n<i>افزودن مدیرکل جدید با شناسه عددی داده شده 🛂</i>\n\n<code>(⚠️ تفاوت مدیر و مدیر‌کل دسترسی به اعطا و یا گرفتن مقام مدیریت است⚠️)</code>\n\nحذف مدیر شناسه\n<i>حذف مدیر یا مدیرکل با شناسه عددی داده شده ✖️</i>\n\nترک گروه\n<i>خارج شدن از گروه و حذف آن از اطلاعات گروه ها 🏃</i>\n\nافزودن همه مخاطبین\n<i>افزودن حداکثر مخاطبین و افراد در گفت و گوهای شخصی به گروه ➕</i>\n\nشناسه من\n<i>دریافت شناسه خود 🆔</i>\n\nبگو متن\n<i>دریافت متن 🗣</i>\n\nارسال کن "شناسه" متن\n<i>ارسال متن به شناسه گروه یا کاربر داده شده 📤</i>\n\nتنظیم نام "نام" فامیل\n<i>تنظیم نام ربات ✏️</i>\n\nتازه سازی ربات\n<i>تازه‌سازی اطلاعات فردی ربات🎈</i>\n<code>(مورد استفاده در مواردی همچون پس از تنظیم نام📍جهت بروزکردن نام مخاطب اشتراکی تبلیغ‌گر📍)</code>\n\nتنظیم نام کاربری اسم\n<i>جایگزینی اسم با نام کاربری فعلی(محدود در بازه زمانی کوتاه) 🔄</i>\n\nحذف نام کاربری\n<i>حذف کردن نام کاربری ❎</i>\n\nتوقف عضویت|تایید لینک|شناسایی لینک|افزودن مخاطب\n<i>غیر‌فعال کردن فرایند خواسته شده</i> ◼️\n\nشروع عضویت|تایید لینک|شناسایی لینک|افزودن مخاطب\n<i>فعال‌سازی فرایند خواسته شده</i> ◻️\n\nحداکثر گروه عدد\n<i>تنظیم حداکثر سوپرگروه‌هایی که تبلیغ‌گر عضو می‌شود،با عدد دلخواه</i> ⬆️\n\nحداقل اعضا عدد\n<i>تنظیم شرط حدقلی اعضای گروه برای عضویت,با عدد دلخواه</i> ⬇️\n\nحذف حداکثر گروه\n<i>نادیده گرفتن حدمجاز تعداد گروه</i> ➰\n\nحذف حداقل اعضا\n<i>نادیده گرفتن شرط حداقل اعضای گروه</i> ⚜️\n\nارسال زمانی روشن|خاموش\n<i>زمان بندی در فروارد و ارسال و افزودن به گروه و استفاده در دستور ارسال</i> ⏲\n\nتنظیم تعداد عدد\n<i>تنظیم گروه های میان وقفه در ارسال زمانی</i>\n\nتنظیم وقفه عدد\n<i>تنظیم وقفه به ثانیه در عملیات زمانی</i>\n\nافزودن با شماره روشن|خاموش\n<i>تغییر وضعیت اشتراک شماره تبلیغ‌گر در جواب شماره به اشتراک گذاشته شده 🔖</i>\n\nافزودن با پیام روشن|خاموش\n<i>تغییر وضعیت ارسال پیام در جواب شماره به اشتراک گذاشته شده ℹ️</i>\n\nتنظیم پیام افزودن مخاطب متن\n<i>تنظیم متن داده شده به عنوان جواب شماره به اشتراک گذاشته شده 📨</i>\n\nلیست مخاطبین|خصوصی|گروه|سوپرگروه|پاسخ های خودکار|لینک|مدیر\n<i>دریافت لیستی از مورد خواسته شده در قالب پرونده متنی یا پیام 📄</i>\n\nمسدودیت شناسه\n<i>مسدود‌کردن(بلاک) کاربر با شناسه داده شده از گفت و گوی خصوصی 🚫</i>\n\nرفع مسدودیت شناسه\n<i>رفع مسدودیت کاربر با شناسه داده شده 💢</i>\n\nوضعیت مشاهده روشن|خاموش 👁\n<i>تغییر وضعیت مشاهده پیام‌ها توسط تبلیغ‌گر (فعال و غیر‌فعال‌کردن تیک دوم)</i>\n\nامار\n<i>دریافت آمار و وضعیت تبلیغ‌گر 📊</i>\n\nوضعیت\n<i>دریافت وضعیت اجرایی تبلیغ‌گر⚙️</i>\n\nتازه سازی\n<i>تازه‌سازی آمار تبلیغ‌گر🚀</i>\n<code>🎃مورد استفاده حداکثر یک بار در روز🎃</code>\n\nارسال به همه|خصوصی|گروه|سوپرگروه\n<i>ارسال پیام جواب داده شده به مورد خواسته شده 📩</i>\n<code>(😄توصیه ما عدم استفاده از همه و خصوصی😄)</code>\n\nارسال به سوپرگروه متن\n<i>ارسال متن داده شده به همه سوپرگروه ها ✉️</i>\n<code>(😜توصیه ما استفاده و ادغام دستورات بگو و ارسال به سوپرگروه😜)</code>\n\nتنظیم جواب "متن" جواب\n<i>تنظیم جوابی به عنوان پاسخ خودکار به پیام وارد شده مطابق با متن باشد 📝</i>\n\nحذف جواب متن\n<i>حذف جواب مربوط به متن ✖️</i>\n\nپاسخگوی خودکار روشن|خاموش\n<i>تغییر وضعیت پاسخگویی خودکار تبلیغ‌گر به متن های تنظیم شده 📯</i>\n\nحذف لینک عضویت|تایید|ذخیره شده\n<i>حذف لیست لینک‌های مورد نظر </i>❌\n\nحذف کلی لینک عضویت|تایید|ذخیره شده\n<i>حذف کلی لیست لینک‌های مورد نظر </i>💢\n🔺<code>پذیرفتن مجدد لینک در صورت حذف کلی</code>🔻\n\nاستارت یوزرنیم\n<i>استارت زدن ربات با یوزرنیم وارد شده</i>\n\nافزودن به همه یوزرنیم\n<i>افزودن کابر با یوزرنیم وارد شده به همه گروه و سوپرگروه ها ➕➕</i>\n\nگروه عضویت باز روشن|خاموش\n<i>عضویت در گروه ها با شرایط توانایی تبلیغ‌گر به افزودن عضو</i>\n\nترک کردن شناسه\n<i>عملیات ترک کردن با استفاده از شناسه گروه 🏃</i>\n\nراهنما\n<i>دریافت همین پیام 🆘</i>\n〰〰〰ا〰〰〰\nسازنده : 					\nکانال : \n<code>آخرین اخبار و رویداد های تبلیغ‌گر را در کانال ما پیگیری کنید.</code>'
          return send(msg.chat_id,msg.id, txt, {_ = 'textParseModeHTML'})
        elseif tostring(msg.chat_id):match("^-") then
          if text:match("^([Ll])$") then
            getChat(msg.chat_id, rem)
            assert (tdbot_function ({
              _ = "setChatMemberStatus",
              chat_id = msg.chat_id,
              user_id = tonumber(bot_id),
              status = {_ = "chatMemberStatusLeft"},
            }, dl_cb, nil))
          end
        end
		
		
	  else

	  if redis:get('botBOT-IDanswer') then
		if Id:match("^(%d+)$") then


	  if not redis:hget('botBOT-ID',Id) then

	  redis:hset('botBOT-ID',Id,"working")
	  local msgtext = redis:get('botBOT-IDfirstmsg')
	  assert (tdbot_function ({
    _ = 'setAlarm',
    seconds = math.random(3,6)
  }, function (i,purya)
		   assert (tdbot_function ({
			_ = 'viewMessages',
			chat_id = i.chatid,
			message_ids = {[0] = i.msgid},
			force_read = 1
		  }, dl_cb, nil))
		  assert (tdbot_function ({
			_ = 'setAlarm',
			seconds = math.random(2,5)
		  }, function (i,purya)
						assert (tdbot_function ({
						_ = 'sendChatAction',
						chat_id = i.chatid,
						action = {
						 _ = 'chatActionTyping',
						  progress = 200
						}
					  }, function (i,purya)
								assert (tdbot_function ({
								_ = 'setAlarm',
								seconds = 6
							  }, function (i,purya)
									  assert (tdbot_function ({
										  _ = "sendMessage",
										  chat_id = i.chatid,
										  reply_to_message_id = 0,
										  disable_notification=false,
										  from_background=true,
										  reply_markup=nil,
										  input_message_content={
											_="inputMessageText",
											text= msgtext ,
											disable_web_page_preview=true,
											clear_draft=false,
											entities={},
											parse_mode=parse}
										  }, dl_cb, nil))
										  
										  	  redis:hset('botBOT-ID',Id,"1")
							  end, {chatid = i.chatid,msgid = i.msgid}))
					  
					  end, {chatid = i.chatid,msgid = i.msgid}))
		  
		  
		  end, {chatid = i.chatid,msgid = i.msgid}))
  
  end, {chatid = Id,msgid = tonumber(math.ceil(msg.id))}))
		
	  elseif redis:hget('botBOT-ID',Id) == "1" then

	  	  redis:hset('botBOT-ID',Id,"working")
	 local msgtext = redis:get('botBOT-IDsecondmsg')


		assert (tdbot_function ({
    _ = 'setAlarm',
    seconds = math.random(200,300)
  }, function (i,purya)
		   assert (tdbot_function ({
			_ = 'viewMessages',
			chat_id = i.chatid,
			message_ids = {[0] = i.msgid},
			force_read = 1
		  }, dl_cb, nil))
		  assert (tdbot_function ({
			_ = 'setAlarm',
			seconds = math.random(2,5)
		  }, function (i,purya)
						assert (tdbot_function ({
						_ = 'sendChatAction',
						chat_id = i.chatid,
						action = {
						 _ = 'chatActionTyping',
						  progress = 200
						}
					  }, function (i,purya)
								assert (tdbot_function ({
								_ = 'setAlarm',
								seconds = 3
							  }, function (i,purya)
									  assert (tdbot_function ({
										  _ = "sendMessage",
										  chat_id = i.chatid,
										  reply_to_message_id = 0,
										  disable_notification=false,
										  from_background=true,
										  reply_markup=nil,
										  input_message_content={
											_="inputMessageText",
											text= msgtext ,
											disable_web_page_preview=true,
											clear_draft=false,
											entities={},
											parse_mode=parse}
										  }, dl_cb, nil))
										  
										  	  	  redis:hset('botBOT-ID',Id,"2")

							  end, {chatid = i.chatid,msgid = i.msgid}))
					  
					  end, {chatid = i.chatid,msgid = i.msgid}))
		  
		  
		  end, {chatid = i.chatid,msgid = i.msgid}))
  
  end, {chatid = Id,msgid = tonumber(math.ceil(msg.id))}))
	  elseif redis:hget('botBOT-ID',Id) == "2" then

	  	 local msgtext = redis:get('botBOT-IDthirdmsg')

	  	  	  redis:hset('botBOT-ID',Id,"working")

	  assert (tdbot_function ({
    _ = 'setAlarm',
    seconds = math.random(200,300)
  }, function (i,purya)
		   assert (tdbot_function ({
			_ = 'viewMessages',
			chat_id = i.chatid,
			message_ids = {[0] = i.msgid},
			force_read = 1
		  }, dl_cb, nil))
		  assert (tdbot_function ({
			_ = 'setAlarm',
			seconds = math.random(2,5)
		  }, function (i,purya)
						assert (tdbot_function ({
						_ = 'sendChatAction',
						chat_id = i.chatid,
						action = {
						 _ = 'chatActionTyping',
						  progress = 200
						}
					  }, function (i,purya)
								assert (tdbot_function ({
								_ = 'setAlarm',
								seconds = 3
							  }, function (i,purya)
									  assert (tdbot_function ({
										  _ = "sendMessage",
										  chat_id = i.chatid,
										  reply_to_message_id = 0,
										  disable_notification=false,
										  from_background=true,
										  reply_markup=nil,
										  input_message_content={
											_="inputMessageText",
											text= msgtext ,
											disable_web_page_preview=true,
											clear_draft=false,
											entities={},
											parse_mode=parse}
										  }, dl_cb, nil))
										  
										  	  	  redis:hset('botBOT-ID',Id,"3")

							  end, {chatid = i.chatid,msgid = i.msgid}))
					  
					  end, {chatid = i.chatid,msgid = i.msgid}))
		  
		  
		  end, {chatid = i.chatid,msgid = i.msgid}))
  
  end, {chatid = Id,msgid = tonumber(math.ceil(msg.id))}))
	  end
	  end
	  
	  end
      end
	 
	 end 
	  
	  
	  end
	
  end
  if (data._ == "updateSupergroup") then 
	if (data.supergroup.status._ == "chatMemberStatusLeft" or data.supergroup.status._ == "chatMemberStatusBanned") then
	local id = "-100".. math.ceil(tonumber(data.supergroup.id))
	if redis:sismember("botBOT-IDall", id) then
	redis:srem("botBOT-IDsupergroups", id)
	redis:srem("botBOT-IDall", id)
	
	end
  end
 end
 
end
