type imgObj = {
  src: string,
  height: int,
  width: int,
  blurDataURL: string,
}
@module("../../../assets/rfq/rfq-index-bg.png")
external rfqBgImg: imgObj = "default"
@module("../../../assets/rfq/rfq-card-1.png")
external rfqCard1: imgObj = "default"
@module("../../../assets/rfq/rfq-card-2.png")
external rfqCard2: imgObj = "default"
@module("../../../assets/rfq/rfq-card-3.png")
external rfqCard3: imgObj = "default"
@module("../../../assets/rfq/rfq-box-img.png")
external rfqBox: imgObj = "default"
@module("../../../assets/rfq/rfq-card-img1.png")
external rfqCardImg1: imgObj = "default"
@module("../../../assets/rfq/rfq-card-img2.png")
external rfqCardImg2: imgObj = "default"
@module("../../../assets/rfq/rfq-card-m1.png")
external rfqCardM1: imgObj = "default"
@module("../../../assets/rfq/rfq-card-m2.png")
external rfqCardM2: imgObj = "default"
@module("../../../assets/rfq/rfq-card-m3.png")
external rfqCardM3: imgObj = "default"
@module("../../../assets/rfq/rfq-card-img-m1.png")
external rfqCardImgM1: imgObj = "default"
@module("../../../assets/rfq/rfq-card-img-m2.png")
external rfqCardImgM2: imgObj = "default"
@module("../../../assets/rfq/rfq-index-bg-m.png")
external rfqBgImgM: imgObj = "default"
module Container = {
  let buttonStyle = %twc(
    "mt-4 lg:mt-[30px] text-lg lg:text-xl text-white tracking-tighter leading-6 px-6 lg:px-8 py-[14px] lg:py-5 bg-primary rounded-lg"
  )

  @react.component
  let make = () => {
    <section className=%twc("relative w-full")>
      <article className=%twc("relative w-full")>
        <img
          src={rfqBgImg.src}
          className=%twc("hidden lg:block absolute object-cover h-full w-full -z-10")
        />
        <img
          src={rfqBgImgM.src} className=%twc("lg:hidden absolute object-cover h-full w-full -z-10")
        />
        <div className=%twc("container max-w-screen-lg mx-auto py-20 lg:py-[110px]")>
          <div
            className=%twc(
              "text-[26px] lg:text-[44px] leading-8 lg:leading-[61.44px] flex justify-center items-center flex-col text-white font-bold  "
            )>
            <h2> {`????????? ?????? ????????? ???????????????`->React.string} </h2>
            <h2>
              <span className=%twc("text-[#05FF00]")> {`?????? ?????? 100%`->React.string} </span>
              {` ???????????????`->React.string}
            </h2>
          </div>
          <div className=%twc("flex justify-center")>
            <RfqCreateRequestButton className=buttonStyle position={#top} />
          </div>
          <div className=%twc("hidden lg:flex justify-center gap-5 mt-[70px]")>
            <img src={rfqCard1.src} className=%twc("w-[333px]") />
            <img src={rfqCard2.src} className=%twc("w-[333px]") />
            <img src={rfqCard3.src} className=%twc("w-[333px]") />
          </div>
          <div className=%twc("flex lg:hidden flex-col items-center mt-10 gap-4")>
            <img src={rfqCardM1.src} className=%twc("w-[280px]") />
            <img src={rfqCardM2.src} className=%twc("w-[280px]") />
            <img src={rfqCardM3.src} className=%twc("w-[280px]") />
          </div>
        </div>
      </article>
      <article className=%twc("relative w-full")>
        <div className=%twc("container max-w-screen-lg mx-auto py-[60px] lg:py-[135px]")>
          <div className=%twc("bg-[#F6F9F6]  rounded-[40px] py-10 lg:py-20 mx-5 lg:mx-0")>
            <div className=%twc("flex lg:block justify-center items-center flex-col lg:px-[72px]")>
              <div className=%twc("text-[26px] lg:text-5xl font-bold")>
                {`?????? `->React.string}
                <span className=%twc("text-primary")> {`????????????`->React.string} </span>
                {` ??????`->React.string}
              </div>
              <div
                className=%twc(
                  "text-[17px] lg:text-2xl leading-6 lg:leading-9 tracking-tighter text-gray-700 mt-4 lg:mt-5"
                )>
                <div className=%twc("hidden lg:block")>
                  <div>
                    {`30??? ????????? ?????? ??????????????? ????????? ????????????`->React.string}
                  </div>
                  <div>
                    {`?????? ?????????????????? ??? ????????? ????????? ?????????????????????.`->React.string}
                  </div>
                </div>
                <div className=%twc("lg:hidden text-center")>
                  <div> {`30??? ????????? ?????? ???????????????`->React.string} </div>
                  <div> {`????????? ???????????? ?????? ??????????????????`->React.string} </div>
                  <div> {`??? ????????? ????????? ?????????????????????.`->React.string} </div>
                </div>
              </div>
            </div>
            <div className=%twc("hidden lg:flex mt-12 justify-end")>
              <img src={rfqCardImg1.src} className=%twc("max-w-[890px]") />
            </div>
            <div className=%twc("lg:hidden mt-8 flex justify-center")>
              <img src={rfqCardImgM1.src} className=%twc("w-full max-w-[280px]") />
            </div>
          </div>
          <div
            className=%twc(
              "relative bg-[#F6F9F6] py-10 lg:py-20 lg:px-[72px] rounded-[40px] mt-5 mx-5 lg:mx-0"
            )>
            <div className=%twc("flex lg:block justify-center items-center flex-col")>
              <div className=%twc("text-[26px] lg:text-5xl font-bold")>
                {`????????? ????????? `->React.string}
              </div>
              <div className=%twc("text-[26px] lg:text-5xl font-bold")>
                <span className=%twc("text-primary")> {`?????? ????????????`->React.string} </span>
              </div>
              <div
                className=%twc(
                  "text-[17px] lg:text-2xl leading-6 lg:leading-9 tracking-tighter text-gray-700 mt-4 lg:mt-5"
                )>
                <div>
                  {`??? ???????????? ????????? ????????? ?????? ????????????`->React.string}
                </div>
                <div>
                  {`????????? ?????? ??????????????? ?????? ??? ????????????.`->React.string}
                </div>
              </div>
              <div className=%twc("hidden lg:block absolute right-0 top-0")>
                <img src={rfqCardImg2.src} className=%twc("max-w-[475px]") />
              </div>
              <div className=%twc("lg:hidden flex justify-center items-center mt-10")>
                <img src={rfqCardImgM2.src} className=%twc("w-full max-w-[320px]") />
              </div>
            </div>
          </div>
        </div>
      </article>
      <div className=%twc("h-0.5 bg-[#DADCDF]") />
      <article className=%twc("relative w-full")>
        <div className=%twc("container max-w-screen-lg mx-auto py-[60px] lg:py-[130px]")>
          <div
            className=%twc(
              "flex flex-col lg:flex-row lg:justify-start gap-[30px] lg:gap-5 px-5 lg:px-0"
            )>
            <div className=%twc("flex justify-center lg:justify-start")>
              <img src={rfqBox.src} className=%twc("w-full max-w-[410px] lg:w-[510px]") />
            </div>
            <div
              className=%twc("lg:pl-[70px] flex justify-center flex-col text-center lg:text-left")>
              <div className=%twc("text-[26px] lg:text-5xl font-bold")>
                {`??? ????????? `->React.string}
                <span className=%twc("text-primary")> {`????????????`->React.string} </span>
              </div>
              <div
                className=%twc(
                  "text-[17px] lg:text-2xl leading-6 lg:leading-9 tracking-tighter text-gray-700 mt-4 lg:mt-5"
                )>
                <div> {`??? ?????? ?????? ?????? ??? ?????? ?????????`->React.string} </div>
                <div> {`????????? 0?????? ?????????????????????.`->React.string} </div>
              </div>
            </div>
          </div>
        </div>
      </article>
      <article className=%twc("relative w-full bg-[#3F4C65]")>
        <div className=%twc("container max-w-screen-lg mx-auto py-[110px]")>
          <div
            className=%twc(
              "hidden lg:flex justify-center items-center flex-col text-white font-bold leading-[61.44px] text-[44px]"
            )>
            <h2>
              {`??? ?????? ??? `->React.string}
              <span className=%twc("text-primary")> {`10?????? ????????????!`->React.string} </span>
            </h2>
            <h2> {` 1????????? ????????? ??????????????????`->React.string} </h2>
            <h3 className=%twc("text-2xl font-normal leading-9 mt-5")>
              {`?????? 3??? ?????? ?????? ???????????? ?????? ?????? 4?????? ???????????? ??????`->React.string}
            </h3>
          </div>
          <div
            className=%twc(
              "flex lg:hidden justify-center items-center flex-col text-white font-bold leading-9 text-[26px]"
            )>
            <h2> {`??? ?????? ??? `->React.string} </h2>
            <h2>
              <span className=%twc("text-primary")> {`10?????? ????????????!`->React.string} </span>
            </h2>
            <h2> {`1?????????`->React.string} </h2>
            <h2> {`????????? ??????????????????`->React.string} </h2>
            <h3 className=%twc("text-[17px] font-normal leading-6 mt-5")>
              {`?????? 3??? ?????? ?????? ????????????`->React.string}
            </h3>
            <h3 className=%twc("text-[17px] font-normal leading-6")>
              {`?????? ?????? 4?????? ???????????? ??????`->React.string}
            </h3>
          </div>
          <div className=%twc("flex justify-center mt-2.5")>
            <RfqCreateRequestButton className=buttonStyle position={#bottom} />
          </div>
        </div>
      </article>
    </section>
  }
}

@react.component
let make = () => {
  <>
    <Next.Head> <title> {`?????? ?????? - ????????????`->React.string} </title> </Next.Head>
    <React.Suspense> <Container /> </React.Suspense>
  </>
}
