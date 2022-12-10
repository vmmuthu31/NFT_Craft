import "react-responsive-carousel/lib/styles/carousel.min.css"; // requires a loader
import { Carousel } from "react-responsive-carousel";
import Header from "./header";

export default function Home() {
  return (
    <div className="bgimg">
      <Header />
      <div className="justify-center align-middle flex  py-16">
        <Carousel
          swipeable="true"
          stopOnHover="true"
          transitionTime={30}
          interval={30}
          autoFocus="true"
          width={800}
        >
          <div>
            <img src="https://user-images.githubusercontent.com/88650559/204961217-3cdb5c14-af31-4f68-af19-ae8e4334b0b2.png" />
            <p className="legend">NFT Hunt</p>
          </div>
          <div>
            <img src="https://user-images.githubusercontent.com/88650559/204961238-24f04aca-d61b-4941-839a-cca2743a1ba2.png" />
            <p className="legend">Game Outline</p>
          </div>
          <div>
            <img src="https://user-images.githubusercontent.com/88650559/204961314-10d98583-fd26-45fa-96c3-f8bfe0eca8ec.png" />
            <p className="legend">The Concept Used</p>
          </div>
          <div>
            <img src="https://user-images.githubusercontent.com/88650559/204961374-ab9bc92d-208b-4593-bd0a-11450edd598c.png" />
            <p className="legend">Legend 3</p>
          </div>
          <div>
            <img src="https://user-images.githubusercontent.com/88650559/204961396-54d366bf-2fd7-4c37-9e78-d61c4badc56e.png" />
            <p className="legend">Legend 3</p>
          </div>
          <div>
            <img src="https://user-images.githubusercontent.com/88650559/204961432-dbf805ca-0def-4d76-ba47-bcad6a226528.png" />
            <p className="legend">Legend 3</p>
          </div>
        </Carousel>
      </div>
    </div>
  );
}
