import React from 'react'
import { BrowserRouter, Route, Routes } from 'react-router-dom'

import '../../../../app/javascript/stylesheets/application.css'
import Layout from '../../layouts/layout'
import Home from '../../pages/home'
import Contracts from '../../pages/contracts'
import Markets from '../../pages/markets'
import Fittings from '../../pages/fittings'
import Orders from '../../pages/orders'
import Inventory from '../../pages/inventory'

export const App = (props) => {
  return (
    <BrowserRouter basename="/beta">
      <Routes>
        <Route
          path="/"
          element={<Layout site={props.site} user={props.user} />}
        >
          <Route index element={<Home />} />
          <Route path="contracts" element={<Contracts />} />
          <Route path="fittings" element={<Fittings />} />
          <Route path="inventory" element={<Inventory />} />
          <Route path="markets" element={<Markets />} />
          <Route path="orders" element={<Orders />} />
        </Route>
      </Routes>
    </BrowserRouter>
  )
}

export default App
