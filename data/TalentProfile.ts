import { w3dataResponse, w3dataRequest, w3dataHandler } from '@/types'

async function getTalentProfile(query: w3dataRequest) {
  var _response = await fetch(`https://api.talentprotocol.com/api/v1/talents/${query.walletAddress?.toLowerCase()}`, {
    headers: {
      'X-API-KEY': process.env.TALENT_PROTOCOL_API_KEY
    }
  });

  if (_response.status !== 200) {
    return null; // Talent not found or an error occurred
  }

  const talentData = await _response.json();

  const response: w3dataResponse = {
    title: `Talent Protocol Profile: *${talentData.talent.username}*`,
    metadata: `Name: ${talentData.talent.name}, Headline: ${talentData.talent.headline}`,
    icon: '/img/talentprotocol.png',
    color: '#4b35ad',
    statistic: `Wallet Address: ${talentData.talent.wallet_address}`,
  }
  return response
}

const handler: w3dataHandler = {
  id: 'talent-profile',
  resolve: getTalentProfile,
}

export default handler;
