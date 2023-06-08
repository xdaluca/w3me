import { w3dataHandler, w3dataRequest, w3dataResponse } from '@/types'
import { ApolloClient, InMemoryCache } from '@apollo/client'
import { gql } from '@apollo/client'

const apolloClient = new ApolloClient({
  uri: 'https://api.lens.dev/',
  cache: new InMemoryCache(),
})

async function getWorldCoin(query: w3dataRequest) {
  const defaultProfile = await apolloClient.query({
    query: gql(`query DefaultProfile($walletAddress: EthereumAddress!) {
      defaultProfile(request: { ethereumAddress: $walletAddress }) {
        id
      }
    }
    `),
    variables: {
      walletAddress: query.walletAddress,
    },
  })

  const profileId = defaultProfile?.data?.defaultProfile?.id
  if (!profileId) return null

  let _response = await apolloClient.query({
    query: gql(`query Profile {
      profile(request: { profileId: "0x8c76" }) {
        onChainIdentity {
          worldcoin {
            isHuman
          }
        }
      }
    }`),
    variables: {
      profileId,
    },
  })

  const isHuman = _response?.data?.profile?.onChainIdentity?.worldcoin?.isHuman
  const title = isHuman ? 'Verified human by *Worldcoin*' : 'Possibly non-human by *Worldcoin*'
  const statistic = isHuman ? 'Eyeballs scanned' : 'Eyeballs never scanned'
  const response: w3dataResponse = {
    title: title,
    metadata: '',
    icon: '/img/worldcoin.png',
    color: '#793AFF',
    statistic: statistic,
  }
  return response
}

const handler: w3dataHandler = {
  id: 'worldcoin',
  resolve: getWorldCoin,
}

export default handler
