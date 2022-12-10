import Image from "next/image";
import { Carousel } from "react-responsive-carousel";
import styles from "../styles/Home.module.css";

export default function Home() {
  return (
    <div className={styles.container}>
      <main className={styles.main}>
        <div className={styles.slideContainer}>
          <Carousel showThumbs={false}>
            <div>
              <img
                alt=""
                src="https://avatars.githubusercontent.com/u/55544488?s=64&v=4"
              />
              <p className="legend">Image </p>
            </div>
          </Carousel>
        </div>
      </main>
    </div>
  );
}
