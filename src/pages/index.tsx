import { Text } from '@chakra-ui/react'
import { Head } from 'components/layout/Head'
import { HeadingComponent } from 'components/layout/HeadingComponent'
import { LinkComponent } from 'components/layout/LinkComponent'

export default function Home() {
  return (
    <>
      <Head />

      <main>
        <HeadingComponent as="h2">w3me</HeadingComponent>
        <Text>Your web3 footprint made easy.</Text>
        <Text py={4}>
          <LinkComponent href="https://github.com/xdaluca/w3me/tree/main/data">View data being fetched</LinkComponent>.
        </Text>
      </main>
    </>
  )
}
