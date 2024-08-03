-- not used in this bot, just practical for any moderation bots

return function(Member, Server, Client)
    local MemberHighest = Member.highestRole
    local ClientMember = Server.me
    local ClientHighest = ClientMember.highestRole

    --print(MemberHighest.position, ClientHighest.position, (MemberHighest.position >= ClientHighest.position))

    return MemberHighest.position >= ClientHighest.position
end