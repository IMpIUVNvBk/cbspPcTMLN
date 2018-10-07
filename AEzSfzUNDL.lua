redislua = (loadfile "redis.lua")()
redis  = redislua.connect('127.0.0.1', 6379)
serpent = (loadfile "serpent.lua")()
http = require("socket.http")
get = http.request
sudo = 595927698
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
		local ran6 = rands(math.random(1,4),'ًںک€ًںکƒًںک„ًںکپًںک†ًںک…ًںک‚ًں¤£âک؛ï¸ڈًںکٹًںک‡ًں™‚ًں™ƒًںک‰ًںکŒًںکچًںککًںک—ًںک™ًںکڑًںک‹ًںکœًںک‌ًںک›ًں¤—ًں¤‘ًں¤“ًںکژًں¤،ًں¤ ًںکڈًںک’ًںک‍ًںک”ًںکںًںک•ًں™پâک¹ï¸ڈًںک£ًںک–ًںک«ًںک©ًںک¤ًںک ًںک،ًںک¶ًںکگًںک‘ًںک¯ًںک¦ًںک§ًںک®ًںک²ًںکµًںک³ًںک±ًںک¨ًںک°ًںک¢ًںک¥ًں¤¤ًںک­ًںک“ًںکھًںک´ًں™„ًں¤”ًں¤¥ًںک¬ًں¤گًں¤¢ًں¤§ًںک·ًں¤’ًں¤•ًںکˆًں‘؟ًںک¼ًںک½ًں™€ًںک؟ًںک¾ًںک»ًںک¹ًںک¸ًںک؛ًں‘گًںڈ»ًں™Œًںڈ½ًں‘ڈًںڈ¾ًں™ڈًںڈ¼ًں¤‌ًں‘چًں‘ژًںڈ½ًں‘ٹًںڈ»âœٹï¸ڈًں¤کًںڈ¼ًں‘Œًں‘Œًںڈ¾ًں‘ˆًںڈ»ًں‘‹ًںڈ»ًں¤™ًںڈ»')
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
          source = get(links[x])
		  if source then
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
			redis:sadd('botBOT-IDbanlist', "ط¨ط§ط²ط¯غŒط¯")
			redis:sadd('botBOT-IDbanlist', "ط´ط§ط±عک")
			redis:sadd('botBOT-IDbanlist', "ظˆغŒظˆ")
			redis:sadd('botBOT-IDbanlist', "Link")
		    redis:sadd('botBOT-IDbanlist', "link")
			redis:sadd('botBOT-IDbanlist', "ط¨ط§ط²ط§ط±")
			redis:sadd('botBOT-IDbanlist', "ط¢ع¯ظ‡غŒ")
			redis:sadd('botBOT-IDbanlist', "Tab")
			redis:sadd('botBOT-IDbanlist', "seen")
			redis:sadd('botBOT-IDbanlist', "طھط¨ظ„غŒط؛")
			redis:sadd('botBOT-IDbanlist', "ظ†غŒط§ط²")
			redis:sadd('botBOT-IDbanlist', "ط³غŒظ†")
			redis:sadd('botBOT-IDbanlist', "ظ„غŒظ†ع©")
			redis:sadd('botBOT-IDbanlist', "ع¯ط³طھط±ط¯ظ‡")
			redis:sadd('botBOT-IDbanlist', "طھط¬ط§ط±طھ")
			redis:sadd('botBOT-IDbanlist', "ع©ط§ظ†ظˆظ†")
			redis:sadd('botBOT-IDbanlist', "طھط¨ط§ط¯ظ„")
			redis:sadd('botBOT-IDbanlist', "ط®ط±غŒط¯")
			redis:sadd('botBOT-IDbanlist', "tab")
			redis:sadd('botBOT-IDbanlist', "ظپط±ظˆط´")
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
		  local autofwd = redis:get('botBOT-IDautoforward') and "âœ…ï¸ڈ" or "â›”ï¸ڈ"
		  local autofwdtime1 = redis:get("botBOT-IDautoforward") and redis:ttl("botBOT-IDautoforward") or 0
		  local autofwdtime = tonumber(autofwdtime1) / 60
		  local afd1 = redis:get('botBOT-IDautoforwarddelay') or 0
		  local afd = tonumber(afd1) / 60
          local naf = redis:get("botBOT-IDmaxforward") and redis:ttl("botBOT-IDmaxforward") or 0
		  local isfwd = redis:get('botBOT-IDfwd_isforwardmode') and "âœ…ï¸ڈ" or "â›”ï¸ڈ"
		  local fwd_targetlistcount = redis:scard('botBOT-IDfwd_targetlist') or "0"
		  local fwd_delay = redis:get('botBOT-IDfwd_delay') or "0"
		  local total = tonumber(fwd_targetlistcount) * tonumber(fwd_delay)
          local offjoin = redis:get("botBOT-IDoffjoin") and "â›”ï¸ڈ" or "âœ…ï¸ڈ"
          local offlink = redis:get("botBOT-IDofflink") and "â›”ï¸ڈ" or "âœ…ï¸ڈ"

          local nlink = redis:get("botBOT-IDlink") and "âœ…ï¸ڈ" or "â›”ï¸ڈ"
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
          send(msg.chat_id, 0, 'ز“wd cخ±ة´celed!')

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
          local txt = 'ًں“چط±ط§ظ‡ظ†ظ…ط§غŒ ط¯ط³طھظˆط±ط§طھ طھط¨ظ„غŒط؛â€Œع¯ط±ًں“چ\n\nط§ظ†ظ„ط§غŒظ†\n<i>ط§ط¹ظ„ط§ظ… ظˆط¶ط¹غŒطھ طھط¨ظ„غŒط؛â€Œع¯ط± âœ”ï¸ڈ</i>\n<code>â‌¤ï¸ڈ ط­طھغŒ ط§ع¯ط± طھط¨ظ„غŒط؛â€Œع¯ط± ط´ظ…ط§ ط¯ع†ط§ط± ظ…ط­ط¯ظˆط¯غŒطھ ط§ط±ط³ط§ظ„ ظ¾غŒط§ظ… ط´ط¯ظ‡ ط¨ط§ط´ط¯ ط¨ط§غŒط³طھغŒ ط¨ظ‡ ط§غŒظ† ظ¾غŒط§ظ… ظ¾ط§ط³ط® ط¯ظ‡ط¯â‌¤ï¸ڈ</code>\n\nط§ظپط²ظˆط¯ظ† ظ…ط¯غŒط± ط´ظ†ط§ط³ظ‡\n<i>ط§ظپط²ظˆط¯ظ† ظ…ط¯غŒط± ط¬ط¯غŒط¯ ط¨ط§ ط´ظ†ط§ط³ظ‡ ط¹ط¯ط¯غŒ ط¯ط§ط¯ظ‡ ط´ط¯ظ‡ ًں›‚</i>\n\nط§ظپط²ظˆط¯ظ† ظ…ط¯غŒط±ع©ظ„ ط´ظ†ط§ط³ظ‡\n<i>ط§ظپط²ظˆط¯ظ† ظ…ط¯غŒط±ع©ظ„ ط¬ط¯غŒط¯ ط¨ط§ ط´ظ†ط§ط³ظ‡ ط¹ط¯ط¯غŒ ط¯ط§ط¯ظ‡ ط´ط¯ظ‡ ًں›‚</i>\n\n<code>(âڑ ï¸ڈ طھظپط§ظˆطھ ظ…ط¯غŒط± ظˆ ظ…ط¯غŒط±â€Œع©ظ„ ط¯ط³طھط±ط³غŒ ط¨ظ‡ ط§ط¹ط·ط§ ظˆ غŒط§ ع¯ط±ظپطھظ† ظ…ظ‚ط§ظ… ظ…ط¯غŒط±غŒطھ ط§ط³طھâڑ ï¸ڈ)</code>\n\nط­ط°ظپ ظ…ط¯غŒط± ط´ظ†ط§ط³ظ‡\n<i>ط­ط°ظپ ظ…ط¯غŒط± غŒط§ ظ…ط¯غŒط±ع©ظ„ ط¨ط§ ط´ظ†ط§ط³ظ‡ ط¹ط¯ط¯غŒ ط¯ط§ط¯ظ‡ ط´ط¯ظ‡ âœ–ï¸ڈ</i>\n\nطھط±ع© ع¯ط±ظˆظ‡\n<i>ط®ط§ط±ط¬ ط´ط¯ظ† ط§ط² ع¯ط±ظˆظ‡ ظˆ ط­ط°ظپ ط¢ظ† ط§ط² ط§ط·ظ„ط§ط¹ط§طھ ع¯ط±ظˆظ‡ ظ‡ط§ ًںڈƒ</i>\n\nط§ظپط²ظˆط¯ظ† ظ‡ظ…ظ‡ ظ…ط®ط§ط·ط¨غŒظ†\n<i>ط§ظپط²ظˆط¯ظ† ط­ط¯ط§ع©ط«ط± ظ…ط®ط§ط·ط¨غŒظ† ظˆ ط§ظپط±ط§ط¯ ط¯ط± ع¯ظپطھ ظˆ ع¯ظˆظ‡ط§غŒ ط´ط®طµغŒ ط¨ظ‡ ع¯ط±ظˆظ‡ â‍•</i>\n\nط´ظ†ط§ط³ظ‡ ظ…ظ†\n<i>ط¯ط±غŒط§ظپطھ ط´ظ†ط§ط³ظ‡ ط®ظˆط¯ ًں†”</i>\n\nط¨ع¯ظˆ ظ…طھظ†\n<i>ط¯ط±غŒط§ظپطھ ظ…طھظ† ًں—£</i>\n\nط§ط±ط³ط§ظ„ ع©ظ† "ط´ظ†ط§ط³ظ‡" ظ…طھظ†\n<i>ط§ط±ط³ط§ظ„ ظ…طھظ† ط¨ظ‡ ط´ظ†ط§ط³ظ‡ ع¯ط±ظˆظ‡ غŒط§ ع©ط§ط±ط¨ط± ط¯ط§ط¯ظ‡ ط´ط¯ظ‡ ًں“¤</i>\n\nطھظ†ط¸غŒظ… ظ†ط§ظ… "ظ†ط§ظ…" ظپط§ظ…غŒظ„\n<i>طھظ†ط¸غŒظ… ظ†ط§ظ… ط±ط¨ط§طھ âœڈï¸ڈ</i>\n\nطھط§ط²ظ‡ ط³ط§ط²غŒ ط±ط¨ط§طھ\n<i>طھط§ط²ظ‡â€Œط³ط§ط²غŒ ط§ط·ظ„ط§ط¹ط§طھ ظپط±ط¯غŒ ط±ط¨ط§طھًںژˆ</i>\n<code>(ظ…ظˆط±ط¯ ط§ط³طھظپط§ط¯ظ‡ ط¯ط± ظ…ظˆط§ط±ط¯غŒ ظ‡ظ…ع†ظˆظ† ظ¾ط³ ط§ط² طھظ†ط¸غŒظ… ظ†ط§ظ…ًں“چط¬ظ‡طھ ط¨ط±ظˆط²ع©ط±ط¯ظ† ظ†ط§ظ… ظ…ط®ط§ط·ط¨ ط§ط´طھط±ط§ع©غŒ طھط¨ظ„غŒط؛â€Œع¯ط±ًں“چ)</code>\n\nطھظ†ط¸غŒظ… ظ†ط§ظ… ع©ط§ط±ط¨ط±غŒ ط§ط³ظ…\n<i>ط¬ط§غŒع¯ط²غŒظ†غŒ ط§ط³ظ… ط¨ط§ ظ†ط§ظ… ع©ط§ط±ط¨ط±غŒ ظپط¹ظ„غŒ(ظ…ط­ط¯ظˆط¯ ط¯ط± ط¨ط§ط²ظ‡ ط²ظ…ط§ظ†غŒ ع©ظˆطھط§ظ‡) ًں”„</i>\n\nط­ط°ظپ ظ†ط§ظ… ع©ط§ط±ط¨ط±غŒ\n<i>ط­ط°ظپ ع©ط±ط¯ظ† ظ†ط§ظ… ع©ط§ط±ط¨ط±غŒ â‌ژ</i>\n\nطھظˆظ‚ظپ ط¹ط¶ظˆغŒطھ|طھط§غŒغŒط¯ ظ„غŒظ†ع©|ط´ظ†ط§ط³ط§غŒغŒ ظ„غŒظ†ع©|ط§ظپط²ظˆط¯ظ† ظ…ط®ط§ط·ط¨\n<i>ط؛غŒط±â€Œظپط¹ط§ظ„ ع©ط±ط¯ظ† ظپط±ط§غŒظ†ط¯ ط®ظˆط§ط³طھظ‡ ط´ط¯ظ‡</i> â—¼ï¸ڈ\n\nط´ط±ظˆط¹ ط¹ط¶ظˆغŒطھ|طھط§غŒغŒط¯ ظ„غŒظ†ع©|ط´ظ†ط§ط³ط§غŒغŒ ظ„غŒظ†ع©|ط§ظپط²ظˆط¯ظ† ظ…ط®ط§ط·ط¨\n<i>ظپط¹ط§ظ„â€Œط³ط§ط²غŒ ظپط±ط§غŒظ†ط¯ ط®ظˆط§ط³طھظ‡ ط´ط¯ظ‡</i> â—»ï¸ڈ\n\nط­ط¯ط§ع©ط«ط± ع¯ط±ظˆظ‡ ط¹ط¯ط¯\n<i>طھظ†ط¸غŒظ… ط­ط¯ط§ع©ط«ط± ط³ظˆظ¾ط±ع¯ط±ظˆظ‡â€Œظ‡ط§غŒغŒ ع©ظ‡ طھط¨ظ„غŒط؛â€Œع¯ط± ط¹ط¶ظˆ ظ…غŒâ€Œط´ظˆط¯طŒط¨ط§ ط¹ط¯ط¯ ط¯ظ„ط®ظˆط§ظ‡</i> â¬†ï¸ڈ\n\nط­ط¯ط§ظ‚ظ„ ط§ط¹ط¶ط§ ط¹ط¯ط¯\n<i>طھظ†ط¸غŒظ… ط´ط±ط· ط­ط¯ظ‚ظ„غŒ ط§ط¹ط¶ط§غŒ ع¯ط±ظˆظ‡ ط¨ط±ط§غŒ ط¹ط¶ظˆغŒطھ,ط¨ط§ ط¹ط¯ط¯ ط¯ظ„ط®ظˆط§ظ‡</i> â¬‡ï¸ڈ\n\nط­ط°ظپ ط­ط¯ط§ع©ط«ط± ع¯ط±ظˆظ‡\n<i>ظ†ط§ط¯غŒط¯ظ‡ ع¯ط±ظپطھظ† ط­ط¯ظ…ط¬ط§ط² طھط¹ط¯ط§ط¯ ع¯ط±ظˆظ‡</i> â‍°\n\nط­ط°ظپ ط­ط¯ط§ظ‚ظ„ ط§ط¹ط¶ط§\n<i>ظ†ط§ط¯غŒط¯ظ‡ ع¯ط±ظپطھظ† ط´ط±ط· ط­ط¯ط§ظ‚ظ„ ط§ط¹ط¶ط§غŒ ع¯ط±ظˆظ‡</i> âڑœï¸ڈ\n\nط§ط±ط³ط§ظ„ ط²ظ…ط§ظ†غŒ ط±ظˆط´ظ†|ط®ط§ظ…ظˆط´\n<i>ط²ظ…ط§ظ† ط¨ظ†ط¯غŒ ط¯ط± ظپط±ظˆط§ط±ط¯ ظˆ ط§ط±ط³ط§ظ„ ظˆ ط§ظپط²ظˆط¯ظ† ط¨ظ‡ ع¯ط±ظˆظ‡ ظˆ ط§ط³طھظپط§ط¯ظ‡ ط¯ط± ط¯ط³طھظˆط± ط§ط±ط³ط§ظ„</i> âڈ²\n\nطھظ†ط¸غŒظ… طھط¹ط¯ط§ط¯ ط¹ط¯ط¯\n<i>طھظ†ط¸غŒظ… ع¯ط±ظˆظ‡ ظ‡ط§غŒ ظ…غŒط§ظ† ظˆظ‚ظپظ‡ ط¯ط± ط§ط±ط³ط§ظ„ ط²ظ…ط§ظ†غŒ</i>\n\nطھظ†ط¸غŒظ… ظˆظ‚ظپظ‡ ط¹ط¯ط¯\n<i>طھظ†ط¸غŒظ… ظˆظ‚ظپظ‡ ط¨ظ‡ ط«ط§ظ†غŒظ‡ ط¯ط± ط¹ظ…ظ„غŒط§طھ ط²ظ…ط§ظ†غŒ</i>\n\nط§ظپط²ظˆط¯ظ† ط¨ط§ ط´ظ…ط§ط±ظ‡ ط±ظˆط´ظ†|ط®ط§ظ…ظˆط´\n<i>طھط؛غŒغŒط± ظˆط¶ط¹غŒطھ ط§ط´طھط±ط§ع© ط´ظ…ط§ط±ظ‡ طھط¨ظ„غŒط؛â€Œع¯ط± ط¯ط± ط¬ظˆط§ط¨ ط´ظ…ط§ط±ظ‡ ط¨ظ‡ ط§ط´طھط±ط§ع© ع¯ط°ط§ط´طھظ‡ ط´ط¯ظ‡ ًں”–</i>\n\nط§ظپط²ظˆط¯ظ† ط¨ط§ ظ¾غŒط§ظ… ط±ظˆط´ظ†|ط®ط§ظ…ظˆط´\n<i>طھط؛غŒغŒط± ظˆط¶ط¹غŒطھ ط§ط±ط³ط§ظ„ ظ¾غŒط§ظ… ط¯ط± ط¬ظˆط§ط¨ ط´ظ…ط§ط±ظ‡ ط¨ظ‡ ط§ط´طھط±ط§ع© ع¯ط°ط§ط´طھظ‡ ط´ط¯ظ‡ â„¹ï¸ڈ</i>\n\nطھظ†ط¸غŒظ… ظ¾غŒط§ظ… ط§ظپط²ظˆط¯ظ† ظ…ط®ط§ط·ط¨ ظ…طھظ†\n<i>طھظ†ط¸غŒظ… ظ…طھظ† ط¯ط§ط¯ظ‡ ط´ط¯ظ‡ ط¨ظ‡ ط¹ظ†ظˆط§ظ† ط¬ظˆط§ط¨ ط´ظ…ط§ط±ظ‡ ط¨ظ‡ ط§ط´طھط±ط§ع© ع¯ط°ط§ط´طھظ‡ ط´ط¯ظ‡ ًں“¨</i>\n\nظ„غŒط³طھ ظ…ط®ط§ط·ط¨غŒظ†|ط®طµظˆطµغŒ|ع¯ط±ظˆظ‡|ط³ظˆظ¾ط±ع¯ط±ظˆظ‡|ظ¾ط§ط³ط® ظ‡ط§غŒ ط®ظˆط¯ع©ط§ط±|ظ„غŒظ†ع©|ظ…ط¯غŒط±\n<i>ط¯ط±غŒط§ظپطھ ظ„غŒط³طھغŒ ط§ط² ظ…ظˆط±ط¯ ط®ظˆط§ط³طھظ‡ ط´ط¯ظ‡ ط¯ط± ظ‚ط§ظ„ط¨ ظ¾ط±ظˆظ†ط¯ظ‡ ظ…طھظ†غŒ غŒط§ ظ¾غŒط§ظ… ًں“„</i>\n\nظ…ط³ط¯ظˆط¯غŒطھ ط´ظ†ط§ط³ظ‡\n<i>ظ…ط³ط¯ظˆط¯â€Œع©ط±ط¯ظ†(ط¨ظ„ط§ع©) ع©ط§ط±ط¨ط± ط¨ط§ ط´ظ†ط§ط³ظ‡ ط¯ط§ط¯ظ‡ ط´ط¯ظ‡ ط§ط² ع¯ظپطھ ظˆ ع¯ظˆغŒ ط®طµظˆطµغŒ ًںڑ«</i>\n\nط±ظپط¹ ظ…ط³ط¯ظˆط¯غŒطھ ط´ظ†ط§ط³ظ‡\n<i>ط±ظپط¹ ظ…ط³ط¯ظˆط¯غŒطھ ع©ط§ط±ط¨ط± ط¨ط§ ط´ظ†ط§ط³ظ‡ ط¯ط§ط¯ظ‡ ط´ط¯ظ‡ ًں’¢</i>\n\nظˆط¶ط¹غŒطھ ظ…ط´ط§ظ‡ط¯ظ‡ ط±ظˆط´ظ†|ط®ط§ظ…ظˆط´ ًں‘پ\n<i>طھط؛غŒغŒط± ظˆط¶ط¹غŒطھ ظ…ط´ط§ظ‡ط¯ظ‡ ظ¾غŒط§ظ…â€Œظ‡ط§ طھظˆط³ط· طھط¨ظ„غŒط؛â€Œع¯ط± (ظپط¹ط§ظ„ ظˆ ط؛غŒط±â€Œظپط¹ط§ظ„â€Œع©ط±ط¯ظ† طھغŒع© ط¯ظˆظ…)</i>\n\nط§ظ…ط§ط±\n<i>ط¯ط±غŒط§ظپطھ ط¢ظ…ط§ط± ظˆ ظˆط¶ط¹غŒطھ طھط¨ظ„غŒط؛â€Œع¯ط± ًں“ٹ</i>\n\nظˆط¶ط¹غŒطھ\n<i>ط¯ط±غŒط§ظپطھ ظˆط¶ط¹غŒطھ ط§ط¬ط±ط§غŒغŒ طھط¨ظ„غŒط؛â€Œع¯ط±âڑ™ï¸ڈ</i>\n\nطھط§ط²ظ‡ ط³ط§ط²غŒ\n<i>طھط§ط²ظ‡â€Œط³ط§ط²غŒ ط¢ظ…ط§ط± طھط¨ظ„غŒط؛â€Œع¯ط±ًںڑ€</i>\n<code>ًںژƒظ…ظˆط±ط¯ ط§ط³طھظپط§ط¯ظ‡ ط­ط¯ط§ع©ط«ط± غŒع© ط¨ط§ط± ط¯ط± ط±ظˆط²ًںژƒ</code>\n\nط§ط±ط³ط§ظ„ ط¨ظ‡ ظ‡ظ…ظ‡|ط®طµظˆطµغŒ|ع¯ط±ظˆظ‡|ط³ظˆظ¾ط±ع¯ط±ظˆظ‡\n<i>ط§ط±ط³ط§ظ„ ظ¾غŒط§ظ… ط¬ظˆط§ط¨ ط¯ط§ط¯ظ‡ ط´ط¯ظ‡ ط¨ظ‡ ظ…ظˆط±ط¯ ط®ظˆط§ط³طھظ‡ ط´ط¯ظ‡ ًں“©</i>\n<code>(ًںک„طھظˆطµغŒظ‡ ظ…ط§ ط¹ط¯ظ… ط§ط³طھظپط§ط¯ظ‡ ط§ط² ظ‡ظ…ظ‡ ظˆ ط®طµظˆطµغŒًںک„)</code>\n\nط§ط±ط³ط§ظ„ ط¨ظ‡ ط³ظˆظ¾ط±ع¯ط±ظˆظ‡ ظ…طھظ†\n<i>ط§ط±ط³ط§ظ„ ظ…طھظ† ط¯ط§ط¯ظ‡ ط´ط¯ظ‡ ط¨ظ‡ ظ‡ظ…ظ‡ ط³ظˆظ¾ط±ع¯ط±ظˆظ‡ ظ‡ط§ âœ‰ï¸ڈ</i>\n<code>(ًںکœطھظˆطµغŒظ‡ ظ…ط§ ط§ط³طھظپط§ط¯ظ‡ ظˆ ط§ط¯ط؛ط§ظ… ط¯ط³طھظˆط±ط§طھ ط¨ع¯ظˆ ظˆ ط§ط±ط³ط§ظ„ ط¨ظ‡ ط³ظˆظ¾ط±ع¯ط±ظˆظ‡ًںکœ)</code>\n\nطھظ†ط¸غŒظ… ط¬ظˆط§ط¨ "ظ…طھظ†" ط¬ظˆط§ط¨\n<i>طھظ†ط¸غŒظ… ط¬ظˆط§ط¨غŒ ط¨ظ‡ ط¹ظ†ظˆط§ظ† ظ¾ط§ط³ط® ط®ظˆط¯ع©ط§ط± ط¨ظ‡ ظ¾غŒط§ظ… ظˆط§ط±ط¯ ط´ط¯ظ‡ ظ…ط·ط§ط¨ظ‚ ط¨ط§ ظ…طھظ† ط¨ط§ط´ط¯ ًں“‌</i>\n\nط­ط°ظپ ط¬ظˆط§ط¨ ظ…طھظ†\n<i>ط­ط°ظپ ط¬ظˆط§ط¨ ظ…ط±ط¨ظˆط· ط¨ظ‡ ظ…طھظ† âœ–ï¸ڈ</i>\n\nظ¾ط§ط³ط®ع¯ظˆغŒ ط®ظˆط¯ع©ط§ط± ط±ظˆط´ظ†|ط®ط§ظ…ظˆط´\n<i>طھط؛غŒغŒط± ظˆط¶ط¹غŒطھ ظ¾ط§ط³ط®ع¯ظˆغŒغŒ ط®ظˆط¯ع©ط§ط± طھط¨ظ„غŒط؛â€Œع¯ط± ط¨ظ‡ ظ…طھظ† ظ‡ط§غŒ طھظ†ط¸غŒظ… ط´ط¯ظ‡ ًں“¯</i>\n\nط­ط°ظپ ظ„غŒظ†ع© ط¹ط¶ظˆغŒطھ|طھط§غŒغŒط¯|ط°ط®غŒط±ظ‡ ط´ط¯ظ‡\n<i>ط­ط°ظپ ظ„غŒط³طھ ظ„غŒظ†ع©â€Œظ‡ط§غŒ ظ…ظˆط±ط¯ ظ†ط¸ط± </i>â‌Œ\n\nط­ط°ظپ ع©ظ„غŒ ظ„غŒظ†ع© ط¹ط¶ظˆغŒطھ|طھط§غŒغŒط¯|ط°ط®غŒط±ظ‡ ط´ط¯ظ‡\n<i>ط­ط°ظپ ع©ظ„غŒ ظ„غŒط³طھ ظ„غŒظ†ع©â€Œظ‡ط§غŒ ظ…ظˆط±ط¯ ظ†ط¸ط± </i>ًں’¢\nًں”؛<code>ظ¾ط°غŒط±ظپطھظ† ظ…ط¬ط¯ط¯ ظ„غŒظ†ع© ط¯ط± طµظˆط±طھ ط­ط°ظپ ع©ظ„غŒ</code>ًں”»\n\nط§ط³طھط§ط±طھ غŒظˆط²ط±ظ†غŒظ…\n<i>ط§ط³طھط§ط±طھ ط²ط¯ظ† ط±ط¨ط§طھ ط¨ط§ غŒظˆط²ط±ظ†غŒظ… ظˆط§ط±ط¯ ط´ط¯ظ‡</i>\n\nط§ظپط²ظˆط¯ظ† ط¨ظ‡ ظ‡ظ…ظ‡ غŒظˆط²ط±ظ†غŒظ…\n<i>ط§ظپط²ظˆط¯ظ† ع©ط§ط¨ط± ط¨ط§ غŒظˆط²ط±ظ†غŒظ… ظˆط§ط±ط¯ ط´ط¯ظ‡ ط¨ظ‡ ظ‡ظ…ظ‡ ع¯ط±ظˆظ‡ ظˆ ط³ظˆظ¾ط±ع¯ط±ظˆظ‡ ظ‡ط§ â‍•â‍•</i>\n\nع¯ط±ظˆظ‡ ط¹ط¶ظˆغŒطھ ط¨ط§ط² ط±ظˆط´ظ†|ط®ط§ظ…ظˆط´\n<i>ط¹ط¶ظˆغŒطھ ط¯ط± ع¯ط±ظˆظ‡ ظ‡ط§ ط¨ط§ ط´ط±ط§غŒط· طھظˆط§ظ†ط§غŒغŒ طھط¨ظ„غŒط؛â€Œع¯ط± ط¨ظ‡ ط§ظپط²ظˆط¯ظ† ط¹ط¶ظˆ</i>\n\nطھط±ع© ع©ط±ط¯ظ† ط´ظ†ط§ط³ظ‡\n<i>ط¹ظ…ظ„غŒط§طھ طھط±ع© ع©ط±ط¯ظ† ط¨ط§ ط§ط³طھظپط§ط¯ظ‡ ط§ط² ط´ظ†ط§ط³ظ‡ ع¯ط±ظˆظ‡ ًںڈƒ</i>\n\nط±ط§ظ‡ظ†ظ…ط§\n<i>ط¯ط±غŒط§ظپطھ ظ‡ظ…غŒظ† ظ¾غŒط§ظ… ًں†ک</i>\nم€°م€°م€°ط§م€°م€°م€°\nط³ط§ط²ظ†ط¯ظ‡ : 					\nع©ط§ظ†ط§ظ„ : \n<code>ط¢ط®ط±غŒظ† ط§ط®ط¨ط§ط± ظˆ ط±ظˆغŒط¯ط§ط¯ ظ‡ط§غŒ طھط¨ظ„غŒط؛â€Œع¯ط± ط±ط§ ط¯ط± ع©ط§ظ†ط§ظ„ ظ…ط§ ظ¾غŒع¯غŒط±غŒ ع©ظ†غŒط¯.</code>'
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
