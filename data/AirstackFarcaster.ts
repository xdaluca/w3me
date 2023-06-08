import { w3dataResponse, w3dataRequest, w3dataHandler } from '@/types'
import { ApolloClient, InMemoryCache } from '@apollo/client'
import { gql } from '@apollo/client'
import { formatDistanceToNow } from 'date-fns'

const apolloClient = new ApolloClient({
  uri: 'https://api.airstack.xyz/gql',
  cache: new InMemoryCache(),
})

async function getAirstackFarcaster(query: w3dataRequest) {
  var _response = await apolloClient.query({
    query: gql(`query SocialHandle {
      Wallet(input: {identity: "${query.walletAddress}", blockchain: ethereum}) {
        socials {
          dappName
          profileName
          profileCreatedAtBlockTimestamp
        }
      }
    }`),
  })

  const farcaster = _response?.data.Wallet?.socials?.[0]
  if (!farcaster) return null

  const createdAt = Date.parse(farcaster.profileCreatedAtBlockTimestamp)

  const response: w3dataResponse = {
    title: `Holder of *${farcaster.profileName}*`,
    metadata: `Profile created ${formatDistanceToNow(createdAt, {
      addSuffix: true,
    })}`,
    icon: '/img/airstack.png',
    color: '#BD00FF',
    statistic: `Registered on *Farcaster*`,
  }
  return response
}

const handler: w3dataHandler = {
  id: 'airstack-farcaster',
  resolve: getAirstackFarcaster,
}

export default handler
