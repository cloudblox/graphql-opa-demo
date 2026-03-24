package bemiddelingsregister.bemiddeling_test

import data.authz.global
import data.bemiddelingsregister.bemiddeling as sut

import rego.v1

test_something if {
	res := sut.error_messages with global.query_ast as graphql.parse_query(query)
		with global.variables as variables
		with input.attributes.request.http.headers.authorization as token

	print(res)
}

token := "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjgyQ0JFODQ2LUQyNEUtNDU4QS1BNkU2LUQ1MDk4RTA5NkQ1MiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhdXRoLm5pZCIsInN1YiI6IjMwMDAwMDAwMTAwMjA4IiwiYXVkIjoiaHR0cHM6Ly9iZW1pZGVsbGluZ3NyZWdpc3Rlci1ucy1kLWRldi1uaWQtMDIua2luZC5sb2NhbC9ncmFwaHFsIiwiZXhwIjoxNzE5NzQ1NDMzLCJuYmYiOjE3MTkxNDA1MTMsImlhdCI6MTcxOTE0MDYzMywianRpIjoiMWU4M2Y3ZTQtNTVjNC00OWNmLWFlZmUtNjdkMTdmNmZlYTRkIiwiX2NsYWltX25hbWVzIjp7ImFnYiI6ImxvY2FsaG9zdCIsInV6b3ZpIjoibG9jYWxob3N0In0sIl9jbGFpbV9zb3VyY2VzIjp7ImxvY2FsaG9zdCI6eyJqd3QiOiJleUpoYkdjaU9pQWlTRk15TlRZaUxDQWlkSGx3SWpvZ0lrcFhWQ0o5LmUzMC5PZHA0QTBGajZOb0tzVjRHeW95MU5BbVNzNktWWmlDMTVTOVZSR1p5UjIwIn19LCJjbGllbnRfaWQiOiIzMDAwMDAwMDEwMDIwOCIsInN1YmplY3RzIjpudWxsLCJzY29wZXMiOlsicmVnaXN0ZXJzL3dsemJlbWlkZGVsaW5nc3JlZ2lzdGVyL2JlbWlkZGVsaW5nZW4vYmVtaWRkZWxpbmc6Y3JlYXRlIl0sImNvbnNlbnRfaWQiOiJiZDQwM2JhNi04ZGE1LTQwN2ItODYzYi0zOWZhNTVkYTUxMDUiLCJjbGllbnRfbWV0YWRhdGEiOm51bGx9.T4Yzo3H9TPW0j8er26kVoXV5QHQznnvi1aSXkiZ3GCkiFFuq2CNSM6kPd4OChB_WDkCrMtbB9yA1R1xNbmGm36RClBvlh7-Sw9u-yu3vI7k3QXLTqTUGhtYYrfDf856uks8q0Ho-z36I3bgosXqtaAsK94Sot7bevolPh86NfoXFL9vbfxMH-30UMvWpBFusLNBMh6lKJyXUWrNChaeuL7JXqHgxwmErw72IZ2LarDmpG0kkpXkCEdqk-pmLWwJka-LgItavLgGWP07SAhi1Jx7eGcl3opwmRdXWmgL75ckzs9jMyWZ7RPf95jbS1pbhe-OKtXQxFuYw2trSNcyYP9jt4lBMHzaOkEiEByFUUet9efpOGOnz7ns45hu5Xm5oeB9e0ByQJGzaxy5RsQYtywXW0Q8MDIklMjYUpZGs-F9NNTi9xvP4QBzlq_I056MDsipfPbIVQ4M1z5WAd8FL8BFh1GHAGhoFLChh4PNkRVfXHazP7sfEtEvKY0urwUyRhX5Lho70XNSF706cq5xQq1537b_VDjExB3wA2gyA2L_aZaLIEaw_lSuvgJYdJ8iuVJT4lfgJnSHzRlJkow_wq8qv4DWETGnYbRXiDuG3r2XfeIK5m4RsMCpsqwVaH07WfmNCKwQVM6s98fDEoiTBHPy8dwyIiZNX198dYzaOS24"

query := `query Bemiddeling($verantwoordelijkZorgkantoor: String!) {
  bemiddeling(
    where: { verantwoordelijkZorgkantoor: { eq: $verantwoordelijkZorgkantoor } }
  ) {
    bemiddelingID
    wlzIndicatieID
    verantwoordelijkZorgkantoor
    verantwoordelijkheidIngangsdatum
    verantwoordelijkheidEinddatum
    bemiddelingspecificatie {
      bemiddelingspecificatieID
      leveringsvorm
      zzpCode
      toewijzingIngangsdatum
      toewijzingEinddatum
      instelling
      uitvoerendZorgkantoor
      vaststellingMoment
      percentage
      opname
      redenIntrekking
      etmalen
      instellingBestemming
      soortToewijzing
    }
    client {
      clientID
      verantwoordelijkZorgkantoor
      bsn
      leefeenheid
      huisarts
      communicatievorm
      taal
      contactpersoon {
        contactpersoonID
        relatienummer
        volgorde
        soortRelatie
        rol
        relatie
        geslachtsnaam
        voorvoegselGeslachtsnaam
        partnernaam
        voorvoegselPartnernaam
        voornamen
        voorletters
        roepnaam
        naamgebruik
        geslacht
        geboortedatum
        geboortedatumgebruik
        ingangsdatum
        einddatum
        contactgegevens {
          contactpersoonContactgegevensID
          adresSoort
          straatnaam
          huisnummer
          huisletter
          huisnummerToevoeging
          postcode
          plaatsnaam
          land
          aanduidingWoonadres
          emailadres
          telefoonnummer01
          landnummer01
          telefoonnummer02
          landnummer02
          ingangsdatum
          einddatum
        }
      }
      contactgegevens {
        clientContactgegevensID
        adresSoort
        straatnaam
        huisnummer
        huisletter
        huisnummerToevoeging
        postcode
        plaatsnaam
        land
        aanduidingWoonadres
        emailadres
        telefoonnummer01
        landnummer01
        telefoonnummer02
        landnummer02
        ingangsdatum
        einddatum
      }
    }
    overdracht {
      overdrachtID
      verantwoordelijkZorgkantoor
      overdrachtDatum
      verhuisDatum
      vaststellingMoment
      overdrachtspecificatie {
        overdrachtspecificatieID
        leveringsstatus
        leveringsstatusClassificatie
        oorspronkelijkeToewijzingEinddatum
      }
    }
  }
}

`

variables := {}
