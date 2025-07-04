class GraphQLQueries {
  // Posts queries
  static const String GET_ALL_POSTINGS = '''
    #graphql
    query GetAllPostings(\$page:Float!) {
      postings:getAllPostings(page:\$page) {
        id
        maximumAge
        minimumFollowers
        inReview
        externalLink
          gender
        extraDetails
          currencyCountry
        agency {
            id
          name
          photo
            username
          instagramStats {
            isVerified
              username
          }
        }
        applicationsCount
        description
        barter
        minimumAge
        open
        title
        currency
        price
        createdAt
        platform
        countries
          states{
              value
              label
          }
          cities{
              value
              label
          }
        hasApplied
        eligibility
        updatedAt
          deliverables
          reviews {
              rating
              photo
              username
          }  
      }
    }
''';
} 