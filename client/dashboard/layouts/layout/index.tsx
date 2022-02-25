import {
  ArchiveIcon,
  CogIcon,
  DocumentTextIcon,
  HomeIcon,
  QuestionMarkCircleIcon,
  ScaleIcon,
  ShoppingBagIcon,
  TemplateIcon
} from '@heroicons/react/outline'
import React, { useState } from 'react'
import { Helmet } from 'react-helmet'
import { Outlet } from 'react-router-dom'

import '../../../../app/javascript/stylesheets/application.css'
import Sidebar from './sidebar'
import MobileMenu from './mobile-menu'
import Topbar from './topbar'

const navigation = [
  { name: 'Dashboard', href: '/', icon: HomeIcon },
  { name: 'Inventory', href: 'inventory', icon: ArchiveIcon },
  { name: 'Orders', href: 'orders', icon: ShoppingBagIcon },
  { name: 'Contracts', href: 'contracts', icon: DocumentTextIcon },
  { name: 'Markets', href: 'markets', icon: ScaleIcon },
  { name: 'Fittings', href: 'fittings', icon: TemplateIcon }
]

const secondaryNavigation = [
  { name: 'Settings', href: '#', icon: CogIcon },
  { name: 'Help', href: '#', icon: QuestionMarkCircleIcon }
]

export const Layout = (props) => {
  const [sidebarOpen, setSidebarOpen] = useState(false)

  const site = props.site
  const user = props.user

  return (
    <>
      <Helmet>
        <body className="h-full bg-background" />
      </Helmet>

      <div className="min-h-full">
        <MobileMenu
          navigation={navigation}
          secondaryNavigation={secondaryNavigation}
          site={site}
          sidebarOpen={sidebarOpen}
          setSidebarOpen={setSidebarOpen}
        />

        <Sidebar
          navigation={navigation}
          secondaryNavigation={secondaryNavigation}
          site={site}
        />

        <div className="lg:pl-64 flex flex-col flex-1">
          <Topbar setSidebarOpen={setSidebarOpen} user={user} />

          <main className="flex-1 mx-4 sm:mx-8 md:mx-48 pb-8">
            <Outlet />
          </main>
        </div>
      </div>
    </>
  )
}

export default Layout
