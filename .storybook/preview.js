import React from 'react'

export const parameters = {
  options: {
    storySort: {
      order: [
        'Foundations',
        ['Overview']
      ]
    }
  }
}

export const decorators = [
  (Story) => (
    <div className="theme">
      {Story()}
    </div>
  )
]
